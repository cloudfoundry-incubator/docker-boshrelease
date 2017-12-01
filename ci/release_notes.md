# Goodbye, cf-containers-broker

Many ppl use docker-boshrelease just for docker; including CFCR/Kubo https://github.com/cloudfoundry-incubator/kubo-deployment/blob/master/manifests/kubo.yml#L13-L16 Currently the release bundles the https://github.com/cloudfoundry-community/cf-containers-broker project for use as an open service broker API.

Thanks to the wonders of the new deployment manifests it is now a lot easier to merge in multiple boshreleases into a single deployment. This makes it easier to extract components into their own boshreleases.

The `cf-containers-broker` job, and the `manifests/broker` manifest + operator files have been moved into https://github.com/cloudfoundry-community/cf-containers-broker-boshrelease. https://github.com/cloudfoundry-community/docker-broker-deployment has also been updated for this new reality.

This BOSH release is now much smaller (no more `ruby`, `eden`, `cf-containers-broker` packages).
