package process_certs

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("Certs file should be broker into individual certs", func() {
	It("should be able to handle empty certs file", func() {
		certs := process("")
		Expect(len(certs)).To(Equal(0))
	})

	It("should be able to handle single cert with surrounding empty space", func() {
		domainName := "mydockerdomain.com"
		certificate := "----BEGIN CERTIFICATE------\n" +
			"-----END CERTIFICATE-----"

		input := "  \n \n " + domainName + "\n" + certificate + "\n" + "  \n    "
		certs := process(input)
		Expect(len(certs)).To(Equal(1))
		Expect(certs[0].domainName).To(Equal(domainName))
		Expect(certs[0].cert).To(Equal(certificate))
	})

	It("should be able handle multiple certs with delimiter", func() {
		domainName1 := "mydockerdomain1.com"
		certificate1 := "----BEGIN CERTIFICATE1------\n" +
			"-----END CERTIFICATE-----"

		domainName2 := "mydockerdomain2.com"
		certificate2 := "----BEGIN CERTIFICATE2------\n" +
			"-----END CERTIFICATE-----"

		delimiter := "*#*#*#*#*#*#*#*#*#*#*#*#*#*#"

		input := " \n " + domainName1 + "\n" + certificate1 + "\n" + delimiter +
			"\n  \t   " + domainName2 + "\n" + certificate2 + " \n \t" + delimiter

		certs := process(input)
		Expect(len(certs)).To(Equal(2))
		Expect(certs[0].domainName).To(Equal(domainName1))
		Expect(certs[0].cert).To(Equal(certificate1))
		Expect(certs[1].domainName).To(Equal(domainName2))
		Expect(certs[1].cert).To(Equal(certificate2))
	})
})
