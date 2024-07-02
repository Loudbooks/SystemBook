package collectors

import (
	"fmt"
	"github.com/coreos/go-systemd/dbus"
	"log"
	"testing"
)

func collectProcesses(t *testing.T) {
	conn, err := dbus.New()
	if err != nil {
		log.Fatalf("Failed to connect to D-Bus: %v", err)
	}
	defer conn.Close()

	units, err := conn.ListUnits()
	if err != nil {
		log.Fatalf("Failed to list units: %v", err)
	}

	for _, unit := range units {
		fmt.Printf("Unit: %s\n", unit.Name)
		fmt.Printf("  Description: %s\n", unit.Description)
		fmt.Printf("  Load State: %s\n", unit.LoadState)
		fmt.Printf("  Active State: %s\n", unit.ActiveState)
		fmt.Printf("  Sub State: %s\n", unit.SubState)
		fmt.Printf("  Enabled: %v\n", unit.LoadState == "loaded")
		fmt.Println()
	}
}
