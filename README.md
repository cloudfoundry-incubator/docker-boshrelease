# Docker deployed by BOSH

If you're already working with Docker images then BOSH is a great way to put them into production. Deploy a complete system on Day 1 and have confidence with Day 2 operational support: resurrection of missing servers, resize host machines, resize disks, update host servers with CVE patches, and much more.

This BOSH release can help. See an example below of a host machine running several Docker containers, all backed by a persistent disk. Also see how to add a `bosh.yml` deployment file to your `Dockerfile` repository to make life easy for your users.

It can also be used to dynamically provision Docker containers running databases and message buses with an API that is [Open Service Broker API](https://www.openservicebrokerapi.org/) compatible. See the [cf-containers-broker-boshrelease](https://github.com/cloudfoundry-community/cf-containers-broker-boshrelease) for more information.

Finally, you can deploy & manage a cluster of Docker Swarm nodes.

Related links:

* [CI](https://ci.kubo.sh/teams/main/pipelines/docker-boshrelease?groups=docker-boshrelease)
* [cf-containers-broker-boshrelease](https://github.com/cloudfoundry-community/cf-containers-broker-boshrelease) * [docker-broker-deployment](https://github.com/cloudfoundry-community/docker-broker-deployment)

## Static set of containers on a VM

Run a static set of Docker containers, backed by a persistent disk:

![ctop-example](manifests/containers/ctop-example.png)

See [`manifests/README.md`](manifests/README.md) for deployment instructions.

### Pair your Dockerfile with a `bosh-service.yml`

Make it super easy for your users to deploy your Docker image upon BOSH by including a `bosh-service.yml` file in the same repo.

Known repos that include a BOSH manifest:

* [`frodenas/docker-redis`](https://github.com/frodenas/docker-redis#deploy-the-image-with-bosh)
* [`frodenas/docker-postgresql`](https://github.com/frodenas/docker-postgresql#deploy-the-image-with-bosh)

For example:

```
git clone https://github.com/frodenas/docker-redis
cd docker-redis
bosh2 deploy bosh-redis.yml --vars-store creds.yml
```

## Docker Swarm

Deploy and manage a cluster of Docker Swarm.

See [`manifests/README.md`](manifests/README.md) for deployment instructions.
