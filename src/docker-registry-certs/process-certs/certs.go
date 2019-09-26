package process_certs

import (
	"io/ioutil"
	"os"
	"regexp"
	"strings"
)

type CertEntry struct {
	domainName string
	cert       string
}

func ProcessCerts(certsPath string) {
	buf, err := ioutil.ReadFile(certsPath)
	if err != nil {
		panic(err)
	}

	certsFileContents := string(buf)
	putToFile(process(certsFileContents))
}

func process(input string) []CertEntry {
	re := regexp.MustCompile("(\\*#)+")
	c := re.Split(input, -1)
	var certs []CertEntry
	certs = make([]CertEntry, 0)

	for _, s := range c {
		s = strings.TrimSpace(s)
		if len(s) != 0 {
			elem := strings.SplitN(s, "\n", 2)
			certs = append(certs, CertEntry{elem[0], elem[1]})
		}
	}
	return certs
}

func putToFile(certs []CertEntry) {
	for _, entry := range certs {
		dirPath := "/etc/docker/certs.d/" + entry.domainName + "/"
		os.MkdirAll(dirPath, 0777)
		filePath := dirPath + "ca.crt"
		err := ioutil.WriteFile(filePath, []byte(entry.cert), 0600)
		if err != nil {
			panic(err)
		}
	}
}
