package main

import (
	"SystemBook/websocket"
	"SystemBook/websocket/listeners"
)

func main() {
	socket := websocket.New()

	socket.RegisterListener("LIST", &listeners.ListListener{})

	socket.Listen()
}
