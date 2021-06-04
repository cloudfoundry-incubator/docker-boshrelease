package cli_test

import (
	"go-src/tests/config"
	. "go-src/tests/helpers"

	"github.com/onsi/gomega/gbytes"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gexec"
)

var _ = Describe("Docker CLI Container Operations", func() {

	var runner *DockerRunner

	BeforeEach(func() {
		h, c, err := config.InitConfig()
		Expect(err).NotTo(HaveOccurred())

		runner = NewDockerRunner(h, c)
		runner.LoadImages()
	})

	AfterEach(func() {
		runner.Cleanup()
	})

	Context("Docker CLI should be able to perform simple container operations", func() {

		It("should be able to run an image and get output", func() {
			s := runner.RunDockerCommand("run", "docker.io/library/hello-world")
			Eventually(s, "120s").Should(gexec.Exit(0))
			Eventually(s, "120s").Should(gbytes.Say("Hello from Docker!"))
		})

		It("should be able to run a command in a container", func() {
			sArg := "command run in alpine"
			s := runner.RunDockerCommand("run", "docker.io/library/alpine", "echo", sArg)
			Eventually(s, "120s").Should(gexec.Exit(0))
			Eventually(s, "120s").Should(gbytes.Say(sArg))
		})
	})

	Context("Docker CLI should be able to run images pulled from private registry", func() {

		It("should be able to run an image and get output", func() {
			imageName := "hello-world"
			runCommands(runner, getCommandsForPrivateRepoImage(imageName))

			s := runner.RunDockerCommand("run", "localhost:5000/"+imageName)
			Eventually(s, "120s").Should(gexec.Exit(0))
			Eventually(s, "120s").Should(gbytes.Say("Hello from Docker!"))
		})

		It("should be able to run a command in a container", func() {
			imageName := "alpine"
			runCommands(runner, getCommandsForPrivateRepoImage(imageName))

			sArg := "command run in alpine"
			s := runner.RunDockerCommand("run", "localhost:5000/"+imageName, "echo", sArg)
			Eventually(s, "120s").Should(gexec.Exit(0))
			Eventually(s, "120s").Should(gbytes.Say(sArg))
		})
	})
})

func getCommandsForPrivateRepoImage(imageName string) [][]string {
	return [][]string{
		{"pull", "docker.io/library/" + imageName},
		{"image", "tag", imageName, "localhost:5000/" + imageName},
		{"push", "localhost:5000/" + imageName},
		{"rmi", "localhost:5000/" + imageName},
		{"pull", "localhost:5000/" + imageName},
	}
}

func runCommands(runner *DockerRunner, commandsAndArgs [][]string) {

	for _, cmdAndArgs := range commandsAndArgs {
		s := runner.RunDockerCommand(cmdAndArgs...)
		Eventually(s, "120s").Should(gexec.Exit(0))
	}
}
