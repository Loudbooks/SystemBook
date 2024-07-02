package collectors

import (
	"fmt"
	"github.com/coreos/go-systemd/v22/dbus"
	"log"
)

func CollectProcesses() {
	conn, err := dbus.NewWithContext(nil)
	if err != nil {
		log.Fatalf("Failed to connect to D-Bus: %v", err)
	}
	defer conn.Close()

	units, err := conn.ListUnitsContext(nil)
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
