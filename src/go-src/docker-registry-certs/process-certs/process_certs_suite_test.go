package process_certs

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestProcessCerts(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "ProcessCerts Suite")
}
