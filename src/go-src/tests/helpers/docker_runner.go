package helpers

import (
	"encoding/json"
	"fmt"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/onsi/gomega/gexec"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

type ContainerSummary struct {
	id   string
	name string
}

type ImgSummary struct {
	id         string
	repository string
}

// DockerRunner ...
type DockerRunner struct {
	hostPath string
	certPath string
}

func (runnner DockerRunner) resolveTLSParams() []string {
	tlsFiles := []string{"ca.pem", "cert.pem", "key.pem"}
	tlsOpts := []string{"tlscacert", "tlscert", "tlskey"}
	tlsArgs := []string{}
	for i := 0; i < 3; i++ {
		tlsArgs = append(tlsArgs, fmt.Sprintf("--%s", tlsOpts[i]), filepath.Join(runnner.certPath, tlsFiles[i]))
	}
	tlsArgs = append(tlsArgs, "--tls")
	return tlsArgs
}

func NewDockerRunner(hostPath, certPath string) *DockerRunner {
	runner := &DockerRunner{
		hostPath: hostPath,
		certPath: certPath,
	}
	return runner
}

// RunDockerCommand ...
func (runner DockerRunner) RunDockerCommand(args ...string) *gexec.Session {
	newArgs := append([]string{"-H", runner.hostPath})
	newArgs = append(newArgs, runner.resolveTLSParams()...)
	newArgs = append(newArgs, args...)

	command := exec.Command("docker", newArgs...)
	session, err := gexec.Start(command, GinkgoWriter, GinkgoWriter)

	Expect(err).NotTo(HaveOccurred())
	return session
}

func (runner DockerRunner) LoadImages() {

	s := runner.RunDockerCommand("pull", "docker.io/library/hello-world")
	Eventually(s, "120s").Should(gexec.Exit(0))

	s = runner.RunDockerCommand("pull", "docker.io/library/alpine")
	Eventually(s, "120s").Should(gexec.Exit(0))
}

func (runner DockerRunner) Cleanup() {

	// Clean up containers
	s := runner.RunDockerCommand("ps", "-a", "--format", `{"id":{{json .ID}},"name":{{json .Names}}}`)
	Eventually(s, "15s").Should(gexec.Exit(0))
	containers := strings.Split(string(s.Out.Contents()), "\n")
	for _, container := range containers {
		if container != "" {
			c := unmarshalContainer(container)
			if c != nil && c.name != "registry" {
				s = runner.RunDockerCommand("rm", c.id)
				Eventually(s, "30s").Should(gexec.Exit(0))
			}
		}
	}

	// Clean up images
	s = runner.RunDockerCommand("images", "--format", `{"id":{{json .ID}},"repository":{{json .Repository}}}`)
	Eventually(s, "15s").Should(gexec.Exit(0))
	images := strings.Split(string(s.Out.Contents()), "\n")
	for _, image := range images {
		if image != "" {
			i := unmarshalImage(image)
			if i != nil && i.repository != "registry" {
				s = runner.RunDockerCommand("rmi", i.repository)
				Eventually(s, "30s").Should(gexec.Exit(0))
			}
		}
	}
}

func unmarshalContainer(data string) *ContainerSummary {
	var c *ContainerSummary
	_ = json.Unmarshal([]byte(data), c)
	return c
}

func unmarshalImage(data string) *ImgSummary {
	var img *ImgSummary
	_ = json.Unmarshal([]byte(data), img)
	return img
}
