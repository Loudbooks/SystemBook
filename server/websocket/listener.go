package websocket

import "SystemBook/json"

type Listener interface {
	HandleMessage(message json.Message, websocket *WebSocket)
}
