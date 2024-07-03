package collectors

import (
	"SystemBook/data"
	"fmt"
	dbusConn "github.com/godbus/dbus/v5"
	"github.com/shirou/gopsutil/process"
	"log"
	"math"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

var Cached []data.Process

func init() {
	Cached = collectProcesses()

	ticker := time.NewTicker(30 * time.Second)
	quit := make(chan struct{})
	go func() {
		for {
			select {
			case <-ticker.C:
				Cached = collectProcesses()
			case <-quit:
				ticker.Stop()
				return
			}
		}
	}()
}

func collectProcesses() []data.Process {
	units, err := listAllUnitNames()
	if err != nil {
		fmt.Println("Failed to collect units...")
	}

	processesList := make([]data.Process, 0)

	var errors = 0
	var totalProcesses = 0

	for _, unit := range units {
		pid, err := getPID(unit.Name)

		if err != nil {
			log.Printf("Failed to gather ID: %v\n", err)
			errors++
			continue
		}

		newProcess, err := process.NewProcess(pid)
		if err != nil {
			dataProcess := data.Process{
				Name:        unit.Name,
				Description: unit.Description,
				Running:     unit.ActiveState == "active",
				Enabled:     unit.LoadState == "loaded",
				Memory:      "None",
				Time:        "None",
				CPU:         "None",
			}

			processesList = append(processesList, dataProcess)
		} else {
			processMemory, _ := newProcess.MemoryInfo()
			rss := formatBytes(processMemory.RSS)

			processCPU, _ := newProcess.CPUPercent()

			processTime, _ := newProcess.CreateTime()
			humanReadable := formatTime(processTime)

			dataProcess := data.Process{
				Name:        unit.Name,
				Description: unit.Description,
				Running:     unit.ActiveState == "active",
				Enabled:     unit.LoadState == "loaded",
				Memory:      rss,
				Time:        strconv.FormatFloat(math.Round(processCPU), 'f', -1, 64) + "%",
				CPU:         humanReadable,
			}

			processesList = append(processesList, dataProcess)
		}

		totalProcesses++
	}

	fmt.Println("Received " + fmt.Sprint(errors) + " errors.")
	fmt.Println("Created " + fmt.Sprint(totalProcesses) + " processes.")

	return processesList
}

func listAllUnitNames() ([]data.Unit, error) {
	conn, err := dbusConn.SystemBus()
	if err != nil {
		log.Fatalf("Failed to connect to system bus: %v", err)
	}

	defer func(conn *dbusConn.Conn) {
		err := conn.Close()
		if err != nil {

		}
	}(conn)

	call := conn.Object("org.freedesktop.systemd1", "/org/freedesktop/systemd1").Call(
		"org.freedesktop.systemd1.Manager.ListUnits",
		0,
	)

	var units []data.Unit

	err = call.Store(&units)
	if err != nil {
		log.Fatalf("Failed to call ListUnits method: %v", err)
	}

	var filteredUnits []data.Unit

	for _, unit := range units {
		if strings.HasSuffix(unit.Name, ".service") {
			filteredUnits = append(filteredUnits, unit)
		}
	}

	return filteredUnits, nil
}

func getPID(service string) (int32, error) {
	cmd := exec.Command("systemctl", "show", service, "--property", "MainPID", "--value")
	out, err := cmd.Output()
	if err != nil {
		return 0, err
	}

	pid, err := strconv.Atoi(strings.Replace(string(out), "\n", "", -1))
	if err != nil {
		return 0, err
	}
	return int32(pid), nil
}

func formatBytes(bytes uint64) string {
	const unit = 1024
	if bytes < unit {
		return fmt.Sprintf("%d B", bytes)
	}
	div, exp := int64(unit), 0
	for n := bytes / unit; n >= unit; n /= unit {
		div *= unit
		exp++
	}
	return fmt.Sprintf("%.1f %cB", float64(bytes)/float64(div), "KMGTPE"[exp])
}

func formatTime(msSinceEpoch int64) string {
	startTime := time.Unix(0, msSinceEpoch*int64(time.Millisecond))

	duration := time.Since(startTime)

	days := int(duration.Hours()) / 24
	hours := int(duration.Hours()) % 24
	minutes := int(duration.Minutes()) % 60

	humanReadable := ""
	if days > 0 {
		humanReadable += fmt.Sprintf("%dd ", days)
	}
	if hours > 0 {
		humanReadable += fmt.Sprintf("%dh ", hours)
	}
	if minutes > 0 {
		humanReadable += fmt.Sprintf("%dm", minutes)
	}

	return humanReadable
}
