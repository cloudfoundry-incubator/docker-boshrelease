package main

import (
	"docker-registry-certs/process-certs"
	"errors"
	"os"
)

func main() {
	args := os.Args
	if len(args) != 2 {
		panic(errors.New("Pass the certs file as argument"))
	}
	process_certs.ProcessCerts(args[1])
}
