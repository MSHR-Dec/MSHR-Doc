package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type Ping struct {
    Status int 
    Result string
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		ping := Ping{http.StatusOK, "ok"}

		res, err := json.Marshal(ping)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(res)
	})
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("ListenAndServe:", err)
	}
}
