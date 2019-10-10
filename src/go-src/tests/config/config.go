package config

import (
	"fmt"
	"os"
)

func InitConfig() (string, string, error) {

	hostPath, err := getDockerEnvVar("DOCKER_HOST")
	certPath, err := getDockerEnvVar("DOCKER_CERT_PATH")

	return hostPath, certPath, err
}

func getDockerEnvVar(key string) (string, error) {
	val := os.Getenv(key)
	if val == "" {
		return "", fmt.Errorf("Environment variable %s not set", key)
	}
	return val, nil
}
