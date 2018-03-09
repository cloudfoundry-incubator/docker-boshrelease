package cli_test

import (
	"tests/config"
	. "tests/helpers"

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
		runner.DeleteAllImages()
	})

	Context("Docker CLI should be able to perform image operations", func() {
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
})
