package main

import (
	"SystemBook/websocket"
	"SystemBook/websocket/listeners"
)

func main() {
	socket := websocket.New()

	monitorListener := listeners.MonitorListener{}

	socket.RegisterListener("LIST", &listeners.ListListener{})
	socket.RegisterListener("MONITOR", &monitorListener)
	socket.RegisterListener("MONITOR-CANCEL", &monitorListener)

	socket.Listen()
}
