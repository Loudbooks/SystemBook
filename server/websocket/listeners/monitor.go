package listeners

import (
	"SystemBook/json"
	websocket2 "SystemBook/websocket"
	"fmt"
	"github.com/coreos/go-systemd/sdjournal"
	"github.com/gorilla/websocket"
	"log"
	"strings"
	"time"
)

type MonitorListener struct{}

var stop = make(chan bool)

func (l *MonitorListener) HandleMessage(message json.Message, connection *websocket.Conn) json.Message {
	if message.Identifier == "MONITOR-CANCEL" {
		stop <- true

		return json.Message{}
	} else {
		stop <- true

		sevenDaysAgo := time.Now().Add(-7 * 24 * time.Hour)
		serviceName := message.Content

		sevenDaysAgoLog := collectJournalEntries(serviceName, sevenDaysAgo)

		stop = make(chan bool)

		go beginLoop(stop, serviceName, connection)

		return json.Message{
			Identifier: "MONITOR",
			Content:    strings.Join(sevenDaysAgoLog, "\n"),
		}
	}
}

func collectJournalEntries(serviceName string, startTime time.Time) []string {
	journal, err := sdjournal.NewJournal()
	if err != nil {
		log.Fatalf("Failed to open journal: %v", err)
	}
	defer func(journal *sdjournal.Journal) {
		err := journal.Close()
		if err != nil {
			fmt.Println("Failed to close journal")
		}
	}(journal)

	usec := uint64(startTime.UnixNano() / 1000)

	err = journal.SeekRealtimeUsec(usec)
	if err != nil {
		log.Fatalf("Failed to seek to the specified time: %v", err)
	}

	err = journal.AddMatch(fmt.Sprintf("_SYSTEMD_UNIT=%s", serviceName))
	if err != nil {
		log.Fatalf("Failed to add match for service: %v", err)
	}

	var textLog []string

	for {
		if n, err := journal.Next(); err != nil || n == 0 {
			break
		}

		entry, err := journal.GetEntry()
		if err != nil {
			log.Fatalf("Failed to get journal entry: %v", err)
		}

		timestamp := time.Unix(0, int64(entry.RealtimeTimestamp)*1000).Format("Jan 2 15:04")
		message := entry.Fields["MESSAGE"]
		println("added log")

		textLog = append(textLog, fmt.Sprintf("%v: %v\n", timestamp, message))
	}

	return textLog
}

func beginLoop(stop chan bool, serviceName string, connection *websocket.Conn) {
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			sevenDaysAgo := time.Now().Add(-1 * time.Second)

			sevenDaysAgoLog := collectJournalEntries(serviceName, sevenDaysAgo)

			if len(sevenDaysAgoLog) <= 0 {
				continue
			}

			websocket2.SendMessage(json.Message{
				Identifier: "MONITOR-LOG",
				Content:    strings.Join(sevenDaysAgoLog, "\n"),
			}, connection)
		case <-stop:
			fmt.Println("Stopping periodic task...")
			return
		}
	}
}
