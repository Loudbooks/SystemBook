package websocket

import (
	"SystemBook/json"
	"bytes"
	"compress/gzip"
	"fmt"
	"github.com/gorilla/websocket"
	"io"
	"net/http"
)

var websocketUpgrader = websocket.Upgrader{
	CheckOrigin: func(request *http.Request) bool {
		return true
	},
}

type WebSocket struct {
	Listeners map[string]Listener
}

func New() *WebSocket {
	socket := WebSocket{
		make(map[string]Listener),
	}

	return &socket
}

func (socket *WebSocket) Listen() {
	socket.prepareHTTP()
}

func (socket *WebSocket) prepareHTTP() {
	fmt.Println("WebSocket server starting on :9002")
	socket.prepareRoutes()
	err := http.ListenAndServe(":9002", nil)
	if err != nil {
		fmt.Println(err)
		return
	}
}

func (socket *WebSocket) prepareRoutes() {
	method := socket.endpoint

	http.HandleFunc("/ws", method)
}

func (socket *WebSocket) RegisterListener(key string, listener Listener) {
	socket.Listeners[key] = listener
}

func (socket *WebSocket) endpoint(responseWriter http.ResponseWriter, request *http.Request) {
	connection, err := websocketUpgrader.Upgrade(responseWriter, request, nil)
	if err != nil {
		fmt.Println(err)
		return
	}

	defer func(connection *websocket.Conn) {
		err := connection.Close()
		if err != nil {
			fmt.Println(err)
		}
	}(connection)

	for {
		_, message, err := connection.ReadMessage()
		if err != nil {
			fmt.Println(err)
			return
		}

		decompressedMessage, err := decompressGzip(message)

		var str string

		if err != nil {
			fmt.Println("Failed to decompress message:", err)
			str = string(message)
		} else {
			str = decompressedMessage
		}

		jsonMessage := json.FromJSON(str)

		fmt.Printf("Received with ID: %s\n", jsonMessage.Identifier)

		response := socket.Listeners[jsonMessage.Identifier].HandleMessage(*jsonMessage, connection)

		compressed, err := compressGzip(response.ToJSON())
		if err != nil {
			fmt.Println("Failed to compress message:", err)
		}

		err = connection.WriteMessage(websocket.BinaryMessage, compressed)
		if err != nil {
			return
		}
	}
}

func decompressGzip(data []byte) (string, error) {
	var buffer bytes.Buffer
	buffer.Write(data)

	gzipReader, err := gzip.NewReader(&buffer)
	if err != nil {
		return "", err
	}
	defer func(gzipReader *gzip.Reader) {
		err := gzipReader.Close()
		if err != nil {
			fmt.Println(err)
		}
	}(gzipReader)

	var result bytes.Buffer
	_, err = io.Copy(&result, gzipReader)
	if err != nil {
		return "", err
	}

	return result.String(), nil
}

func compressGzip(data string) ([]byte, error) {
	var buffer bytes.Buffer
	gzipWriter := gzip.NewWriter(&buffer)

	_, err := gzipWriter.Write([]byte(data))
	if err != nil {
		return nil, err
	}

	err = gzipWriter.Close()
	if err != nil {
		return nil, err
	}

	return buffer.Bytes(), nil
}
