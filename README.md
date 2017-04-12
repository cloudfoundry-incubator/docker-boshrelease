# Docker deployed by BOSH

If you're already working with Docker images then BOSH is a great way to put them into production. Deploy a complete system on Day 1 and have confidence with Day 2 operational support: resurrection of missing servers, resize host machines, resize disks, update host servers with CVE patches, and much more.

This BOSH release can help. It can also be used to dynamically provision Docker containers running databases and message buses with an API that is [Open Service Broker API](https://www.openservicebrokerapi.org/) compatible.

Related links:

* [CI](https://ci.starkandwayne.com/teams/main/pipelines/docker-boshrelease)

## Dynamically provision containers via Open Service Broker API

This BOSH release includes a `cf-containers-broker` job provides an API that can provision new Docker containers running PostgreSQL/MySQL/Redis/whatever on demand. The API is [Open Service Broker API](https://www.openservicebrokerapi.org/) compatible, which means you can register it with Cloud Foundry, Kubernetes and more.

Allow users to dynamically provision persistent services, running in Docker containers, using the `cf` Cloud Foundry CLI:

![cf-create-service-ctop](manifests/broker/cf-create-service-ctop.gif)

The example usage is MySQL 5.6: each provisioned service is running inside a dedicated Docker container. The service provides credentials that look like:

```
$ cf create-service mysql56 free mysql1
$ cf create-service-key mysql1 mysql1-key
$ cf service-key mysql1 mysql1-key
{
 "dbname": "wcfh1voergicdt9n",
 "hostname": "10.244.33.0",
 "password": "mlasvy5fpq9zx8mb",
 "port": "32770",
 "ports": {
  "3306/tcp": "32770"
 },
 "uri": "mysql://duawbyody1ashrgr:mlasvy5fpq9zx8mb@10.244.33.0:32770/wcfh1voergicdt9n",
 "username": "duawbyody1ashrgr"
}
```

See [docker-broker-deployment](https://github.com/cloudfoundry-community/docker-broker-deployment) for a dedicated repo that is all about deploying an Open Service Broker API compatible cluster that runs your favourite services inside on-demand Docker containers.

This repo is similar/same as `manifests/broker` folder, which is used for the CI test harness.

## Static set of containers on a VM

Run a static set of Docker containers, backed by a persistent disk:

![ctop-example](manifests/containers/ctop-example.png)

See [`manifests/README.md`](manifests/README.md) for deployment instructions.

## Docker Swarm

Deploy and manage a cluster of Docker Swarm.

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
