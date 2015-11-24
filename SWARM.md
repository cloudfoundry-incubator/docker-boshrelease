# Deploy a Docker Swarm cluster

In this scenario you can deploy a Docker [Swarm](https://github.com/docker/swarm) cluster.

## Example

Create a deployment file using as a starting point one the `docker-swarm-<Iaas>.yml` files  located at the
[examples](https://github.com/cloudfoundry-community/docker-boshrelease/tree/master/examples) directory:

```
vi path/to/deployment.yml
```

Note that the examples requires you to open some ports, so you will need to:

* Create a security group (or the equivalent) named `bosh` with the following ports opened:
    - TCP `22`, `4222`, `6868`, `25250`, `25555`, `25777` to enable BOSH to communicate with the agents
    - UDP `53` to enable using the BOSH DNS
* Create a security group (or the equivalent) named `docker-swarm` (or the name of your deployment) with the following ports opened:
    - TCP `2375` for Docker Swarm API

Note also that the example uses a static list of IP addresses as the [Discovery backend](https://docs.docker.com/swarm/discovery/). For a production environment, it is recommended to use [Consul](https://www.consul.io/), [etcd](https://coreos.com/etcd/) or [Zookeeper](https://zookeeper.apache.org/) for [Discovery backend](https://docs.docker.com/swarm/discovery/) and a[Highly Availability](https://docs.docker.com/swarm/multi-manager-setup/).
