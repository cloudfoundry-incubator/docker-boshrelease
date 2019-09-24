package cli_test

import (
	"go-src/tests/config"
	. "go-src/tests/helpers"

	"github.com/onsi/gomega/gbytes"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gexec"
)

var _ = Describe("Docker CLI Image Operations", func() {

	var runner *DockerRunner

	BeforeEach(func() {
		h, c, err := config.InitConfig()
		Expect(err).NotTo(HaveOccurred())

		runner = NewDockerRunner(h, c)
	})

	AfterEach(func() {
		runner.Cleanup()
	})

	Context("Docker CLI should be able to perform simple image operations", func() {
		It("should be able to pull images from an external registry", func() {
			s := runner.RunDockerCommand("pull", "docker.io/library/alpine")
			Eventually(s, "120s").Should(gexec.Exit(0))
			Eventually(s).Should(gbytes.Say("alpine"))
		})

		It("should be able to list images", func() {
			s := runner.RunDockerCommand("pull", "docker.io/library/alpine")
			Eventually(s, "120s").Should(gexec.Exit(0))

			s = runner.RunDockerCommand("images")
			Eventually(s, "15s").Should(gexec.Exit(0))
			Eventually(s).Should(gbytes.Say("alpine"))
		})
	})

	Context("Docker CLI should be able to delete a pulled image", func() {
		It("should be able delete an existing image", func() {
			By("pull an image locally")
			s := runner.RunDockerCommand("pull", "docker.io/library/alpine")
			Eventually(s, "120s").Should(gexec.Exit(0))

			By("delete an existing image")
			s = runner.RunDockerCommand("rmi", "docker.io/library/alpine")
			Eventually(s, "120s").Should(gexec.Exit(0))
			Eventually(s).Should(gbytes.Say("Untagged: alpine"))
		})
	})

	Context("Docker CLI should be able to work with a private registry", func() {
		It("should be able to pull/push from/to a private registry", func() {
			By("pull an image locally")
			s := runner.RunDockerCommand("pull", "docker.io/library/hello-world")
			Eventually(s, "120s").Should(gexec.Exit(0))

			By("tag the image")
			s = runner.RunDockerCommand("image", "tag", "hello-world", "localhost:5000/hello-world")
			Eventually(s, "20s").Should(gexec.Exit(0))

			By("push to the local registry")
			s = runner.RunDockerCommand("push", "localhost:5000/hello-world")
			Eventually(s, "120s").Should(gexec.Exit(0))

			By("pull from the local registry", func() {
				By("remove the pushed image")
				s = runner.RunDockerCommand("rmi", "localhost:5000/hello-world")
				Eventually(s, "120s").Should(gexec.Exit(0))

				By("pull the image from the registry")
				s = runner.RunDockerCommand("pull", "localhost:5000/hello-world")
				Eventually(s, "120s").Should(gexec.Exit(0))

				By("images list contains that image")
				s = runner.RunDockerCommand("images")
				Eventually(s, "20s").Should(gexec.Exit(0))
				Eventually(s).Should(gbytes.Say("localhost:5000/hello-world"))
			})
		})

	})
})
