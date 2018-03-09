package cli_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	"testing"
)

func TestCli(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Docker Cli Suite")
}

var _ = BeforeSuite(func() {
	// var err error
	// testconfig, err = config.InitConfig()
	// Expect(err).NotTo(HaveOccurred())
})
