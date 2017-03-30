# Broker services

This folder contains a collection of BOSH operator patch files that can be merged into the `docker-broker.yml` deployment file to add Docker-backed services. Each one specifies a different base service type and a specific major version family (`op-postgresql96.yml` contains PostgreSQL 9.6).

The files reference tagged Docker images from Docker Hub (`op-postgresql96.yml` references `frodenas/postgresql:9.6`) It is assumed that upgrades within each tagged Docker image can be rolled out and all existing Docker containers can be upgraded without effort. If not, then a new tagged Docker image should be published and a new service file created.

There are two sets of files in this folder - relatively maintained services and a collection of older Docker images that have not recently been upgraded. The latter should work, but contain older software and have perhaps not been tested recently. If you wish to help upgrade an old Docker image, created an Issue to ask how to help or find @drnic on https://slack.cloudfoundry.org

Relatively maintained services:

* MySQL 5.6 - `op-mysql56.yml` from https://github.com/frodenas/docker-mysql
* PostgreSQL 9.6 - `op-postgresql96.yml` from https://github.com/frodenas/docker-postgresql
* Redis 3.2 - `op-redis32.yml` from https://github.com/frodenas/docker-redis

The source Dockerfile and internal scripts are found in the repository linked above. Also the `documentationUrl` field links to this repository in each service file.

Relatively unmaintained services are without the `op-` prefix.
