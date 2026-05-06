package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"path"
	"strings"

	"github.com/godbus/dbus/v5"
	"github.com/google/uuid"
)

type Config struct {
	Topic string `json:"topic,omitempty"`
	Mode  string `json:"mode,omitempty"`
}

type Message struct {
	Event    string `json:"event,omitempty"`
	Message  string `json:"message,omitempty"`
	Priority int    `json:"priority,omitempty"`
	Title    string `json:"title,omitempty"`
}

func sender(topic string) {
	args := flag.Args()
	if len(args) == 0 {
		log.Fatal("Not enough arguments for send")
	}
	if len(args) > 2 {
		log.Fatal("Too many arguments for send")
	}

	url := url.URL{
		Scheme: "https",
		Host:   "ntfy.sh",
		Path:   topic,
	}
	req, _ := http.NewRequest("POST", url.String(),
		strings.NewReader(args[len(args)-1]))
	if len(args) == 2 {
		req.Header.Set("Title", args[len(args)-2])
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	log.Print(string(body))
}

func receiver(topic string) {
	// Setup D-Bus connection
	conn, err := dbus.ConnectSessionBus()
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	obj := conn.Object("org.freedesktop.Notifications", "/org/freedesktop/Notifications")

	// Connect to ntfy endpoint
	path, err := url.JoinPath(topic, "json")
	if err != nil {
		log.Fatal(err)
	}
	url := url.URL{
		Scheme: "https",
		Host:   "ntfy.sh",
		Path:   path,
	}
	resp, err := http.Get(url.String())
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	scanner := bufio.NewScanner(resp.Body)

	// Wait for messages
	for scanner.Scan() {
		log.Print(scanner.Text())

		msg := Message{
			Event:    "",
			Message:  "",
			Priority: 3,
			Title:    "",
		}
		if err := json.Unmarshal(scanner.Bytes(), &msg); err != nil {
			log.Fatal(err)
		}

		if msg.Event != "message" {
			continue
		}

		summary := ""
		body := ""
		hints := map[string]dbus.Variant{
			"urgency": dbus.MakeVariant(2),
		}

		if msg.Title != "" {
			summary = msg.Title
			body = msg.Message
		} else if len(msg.Message) > 32 {
			summary = msg.Message[:32] + "…"
			body = msg.Message
		} else {
			summary = msg.Message
		}

		if call := obj.Call("org.freedesktop.Notifications.Notify", 0,
			"ntfy.sh/"+topic, // app_name
			uint32(0),        // replaces_id
			"",               // app_icon
			summary,          // summary
			body,             // body
			[]string{},       // actions
			hints,            // hints
			int32(5000),      // expire_timeout
		); call.Err != nil {
			log.Fatal(call.Err)
		}
	}
}

func main() {
	var config Config
	var configFilePath string

	// Parse config file
	configDir, err := os.UserConfigDir()
	if err != nil {
		log.Fatal(err)
	} else {
		configFilePath = path.Join(configDir, "ntfy-send", "config.json")
		configFile, err := os.OpenFile(configFilePath, os.O_RDONLY, 0644)
		if err != nil {
			log.Print(err)
		} else {
			defer configFile.Close()
			bytes, _ := io.ReadAll(configFile)
			err = json.Unmarshal(bytes, &config)
			if err != nil {
				log.Print(err)
			}
		}
	}

	// Parse command line flags
	topic := &config.Topic
	mode := new(string)
	flag.StringVar(topic, "topic", config.Topic, "Topic to subscribe to")
	flag.StringVar(mode, "mode", config.Mode, "Operating mode (sender/receiver)")
	flag.Parse()

	if *topic == "" {
		config.Topic = uuid.New().String()
		bytes, err := json.MarshalIndent(config, "", "    ")
		if err != nil {
			log.Fatal(err)
		}
		err = os.Mkdir(path.Dir(configFilePath), 0755)
		if err != nil {
			log.Fatal(err)
		}
		configFile, err := os.OpenFile(configFilePath, os.O_RDWR|os.O_CREATE, 0644)
		if err != nil {
			log.Fatal(err)
		} else {
			defer configFile.Close()
			_, err := io.WriteString(configFile, string(bytes))
			if err != nil {
				log.Fatal(err)
			}
		}
	}

	if *mode == "sender" {
		sender(*topic)
	} else if *mode == "receiver" {
		receiver(*topic)
	} else {
		log.Fatalf("No such operating mode: %s", *mode)
	}
}
