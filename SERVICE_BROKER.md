# Deploy a Docker Service Broker for your Cloud Foundry deployment

In this scenario you can deploy a [Service Broker](http://docs.cloudfoundry.org/services/overview.html) for your
Cloud Foundry deployment that will use Docker containers for your services.

See [Managing Stateful Docker Containers with Cloud Foundry BOSH](http://blog.pivotal.io/cloud-foundry-pivotal/products/managing-stateful-docker-containers-with-cloud-foundry-bosh) for more details.

## Example

Create a deployment file using as a starting point one the files `docker-broker-<Iaas>.yml` located at the
[examples](https://github.com/cf-platform-eng/docker-boshrelease/tree/master/examples) directory.

## Properties format

Refer to the [Containers Service Broker for Cloud Foundry](https://github.com/cf-platform-eng/cf-containers-broker/blob/master/README.md)
repository for details about how to configure the service broker.
