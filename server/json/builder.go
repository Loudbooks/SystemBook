package json

import "encoding/json"

type Message struct {
	Identifier string      `json:"identifier"`
	Content    interface{} `json:"content"`
}

func (message *Message) ToJSON() string {
	marshal, err := json.Marshal(message)
	if err != nil {
		return ""
	}

	return string(marshal)
}

func FromJSON(jsonString string) *Message {
	message := Message{}
	err := json.Unmarshal([]byte(jsonString), &message)
	if err != nil {
		return nil
	}

	return &message
}
