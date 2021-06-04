package main

import (
	"errors"
	"go-src/docker-registry-certs/process-certs"
	"os"
)

func main() {
	args := os.Args
	if len(args) != 2 {
		panic(errors.New("Pass the certs file as argument"))
	}
	process_certs.ProcessCerts(args[1])
}
