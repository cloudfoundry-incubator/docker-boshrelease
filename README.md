# Docker deployed by BOSH

One of the fastest ways to get [Docker](https://www.docker.io/) and orchestrate containers with persistent data on any infrastructure is to deploy this BOSH release.

Run a static set of Docker containers, backed by a persistent disk:

![ctop-example](manifests/containers/ctop-example.png)

Allow users to dynamically provision persistent services, running in Docker containers, using the `cf` Cloud Foundry CLI:

![cf-create-service-ctop](manifests/broker/cf-create-service-ctop.gif)
