# Deployment

There are three basic use cases supported by the Docker BOSH release:

* statically configure and run one or more containers
* service broker to allow dynamic provisioning of containers
* docker swarm - manager and many backend docker vms

## Static containers

```
export BOSH_DEPLOYMENT=containers-example
bosh2 deploy manifests/containers/example.yml
```

By default above Docker daemon is only available locally via a `$DOCKER_SOCK` socket.

To expose the Docker daemon externally via TCP port, include the `op-public-tls.yml` operator patch file:

```
export BOSH_DEPLOYMENT=containers-example
bosh2 deploy manifests/containers/example.yml \
  -o manifests/op-public-tls.yml \
  --vars-store tmp/creds.yml
```

The first time you run this it will automatically generate a root CA and TLS certificate and store it in `tmp/creds.yml`.

## Brokered containers

Simplest way to add service brokers to your Cloud Foundry. For the example below, the resulting marketplace will look like:

```
$ cf marketplace

service        plans   description
mysql56        free    MySQL 5.6 service for application development and testing
postgresql96   free    PostgreSQL 9.6 service for application development and testing
redis32        free    Redis 3.2 service for application development and testing
```

The example above was created using the following deployment:

```
export BOSH_DEPLOYMENT=docker-broker
bosh2 deploy manifests/broker/docker-broker.yml \
  --vars-store tmp/creds.yml \
  -o manifests/broker/services/op-postgresql96.yml \
  -o manifests/broker/services/op-mysql56.yml \
  -o manifests/broker/services/op-redis32.yml
```

See `manifests/broker/services/*.yml` for example service catalogs you can include in your service broker deployment.

Once deployed, you can dynamically provision new Docker containers using the Service Broker API.

Users can now provision new services, each running inside a Docker container, using the `cf create-service` command:

```
$ cf create-service redis32 free redis1
$ cf create-service redis32 free redis2
$ cf create-service mysql56 free mysql1
$ cf create-service postgresql96 free pg1
```

![cf-create-service-ctop](broker/cf-create-service-ctop.gif)

### Integration with Cloud Foundry

You can also integrate your service broker with your Cloud Foundry.

```
export BOSH_DEPLOYMENT=docker-broker
bosh2 deploy manifests/broker/docker-broker.yml --vars-store tmp/creds.yml \
  -o manifests/op-cf-integration.yml \
  -o manifests/broker/services/op-postgresql96.yml \
  -o manifests/broker/services/op-mysql56.yml \
  -o manifests/broker/services/op-redis32.yml

bosh2 run-errand broker-registrar
```

Each of your services will be now available in the service catalog/marketplace:

```
cf marketplace
```

## Docker Swarm

The docker swarm deployment includes automatic generation of TLS certificates that are shared between docker + swarm manager:

```
export BOSH_DEPLOYMENT=docker-swarm
bosh2 deploy manifests/swarm/docker-swarm.yml --vars-store tmp/creds.yml
```
