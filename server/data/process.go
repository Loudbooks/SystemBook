package data

type Process struct {
	Description string `json:"description"`
	Name        string `json:"name"`
	Running     bool   `json:"running"`
	Enabled     bool   `json:"enabled"`
	Memory      string `json:"memory"`
	Time        string `json:"time"`
	CPU         string `json:"cpu"`
}
