# Deploy a Docker Service Broker for your Cloud Foundry deployment

In this scenario you can deploy a [Service Broker](http://docs.cloudfoundry.org/services/overview.html) for your Cloud Foundry deployment that will use [Docker containers](https://www.docker.com/) for your services.

See [Docker Service Broker for Cloud Foundry](http://blog.pivotal.io/cloud-foundry-pivotal/products/docker-service-broker-for-cloud-foundry) for more details.

## Example

Create a deployment file using as a starting point one the `docker-broker-<Iaas>.yml` files located at the [examples](https://github.com/cf-platform-eng/docker-boshrelease/tree/master/examples) directory.

```
vi path/to/deployment.yml
```

Note that the examples requires you to open some ports, so you will need to:

* Create a security group (or the equivalent) named `bosh` with the following ports opened:
    - TCP `22`, `4222`, `6868`, `25250`, `25555`, `25777` to enable BOSH to communicate with the agents
    - UDP `53` to enable using the BOSH DNS
* Create a security group (or the equivalent) named `docker-broker` (or the name of your deployment) with the following ports opened:
    - All TCP/UDP ports from your Cloud Foundry deployment

## Properties format

Refer to the [Containers Service Broker for Cloud Foundry](https://github.com/cf-platform-eng/cf-containers-broker#usage) repository for details about how to configure the service broker.
