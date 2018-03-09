package helpers

import (
	"fmt"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/onsi/gomega/gexec"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

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

func (runner DockerRunner) DeleteAllImages() {
	s := runner.RunDockerCommand("images", "--quiet")
	Eventually(s, "15s").Should(gexec.Exit(0))

	ids := strings.Split(string(s.Out.Contents()), "\n")
	for _, id := range ids {
		fmt.Println(id)
		if id != "" {
			s = runner.RunDockerCommand("rmi", id)
			Eventually(s, "30s").Should(gexec.Exit(0))
		}
	}
}
