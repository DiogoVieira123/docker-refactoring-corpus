package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

func main() {
	addr := os.Getenv("AUTHD_ADDR")
	if addr == "" {
		addr = ":4000"
	}

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("content-type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
	})

	log.Printf("authd listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}
