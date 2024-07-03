package websocket

import (
	"SystemBook/json"
	"github.com/gorilla/websocket"
)

type Listener interface {
	HandleMessage(message json.Message, connection *websocket.Conn) json.Message
}
