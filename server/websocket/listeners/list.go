package listeners

import (
	"SystemBook/collectors"
	"SystemBook/json"
	json2 "encoding/json"
	"fmt"
	"github.com/gorilla/websocket"
)

type ListListener struct{}

func (l *ListListener) HandleMessage(_ json.Message, _ *websocket.Conn) string {
	data := map[string]interface{}{
		"processes": collectors.Cached,
	}

	outputJson, err := json2.Marshal(data)
	if err != nil {
		fmt.Println("Failed to parse JSON: ", err)
		return ""
	}

	return string(outputJson)
}
