package main

import (
	"flag"
	"fmt"
)

func main() {
	subject := flag.String("subject", "", "subject to inspect")
	flag.Parse()

	if *subject == "" {
		fmt.Println("authctl ready")
		return
	}

	fmt.Printf("inspecting %s\n", *subject)
}
