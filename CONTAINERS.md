# Deploy statically defined Docker containers

In this scenario you can deploy Docker containers statically defined at your deployment manifest.

See [Managing Stateful Docker Containers with Cloud Foundry BOSH](http://blog.pivotal.io/cloud-foundry-pivotal/products/managing-stateful-docker-containers-with-cloud-foundry-bosh) for more details.

## Example

Create a deployment file using as a starting point one the `docker-<Iaas>.yml` files located at the
[examples](https://github.com/cloudfoundry-community/docker-boshrelease/tree/master/examples) directory:

```
vi path/to/deployment.yml
```

Note that the examples requires you to open some ports, so you will need to:

* Create a security group (or the equivalent) named `bosh` with the following ports opened:
    - TCP `22`, `4222`, `6868`, `25250`, `25555`, `25777` to enable BOSH to communicate with the agents
    - UDP `53` to enable using the BOSH DNS
* Create a security group (or the equivalent) named `docker` (or the name of your deployment) with the following ports opened:
    - TCP `3306` for MySQL
    - TCP `6379` for Redis
    - TCP `9200` & `9300` for ElasticSearch

## Properties format

Containers to be deployed must be specified at the properties section of each job. The format is:

| Field | Required | Type | Description
|:------|:--------:|:---- |:-----------
| containers[] | Y | Array  | Containers to deploy
| containers[].name | Y | String | Name to assign to the container
| containers[].image | Y | String | Name of the image to create or the image fo fetch and run from the registry
| containers[].dockerfile | N | String (Literal Style) | Contents of the Dockerfile (when you want to build a Docker image)
| containers[].command | N | String | Command to the run the container (including arguments)
| containers[].blkio_weight | N | String | Block IO (relative weight)
| containers[].cap_adds[] | N | Array of Strings | Linux capabilities to add
| containers[].cap_drops[] | N | Array of Strings | Linux capabilities to drop
| containers[].period | N | String | CPU CFS (Completely Fair Scheduler) period limit
| containers[].cpu_quota | N | String | CPU CFS (Completely Fair Scheduler) quota limit
| containers[].cpu_shares | N | String | CPU shares to assign to the container (relative weight)
| containers[].depends_on[] | N | Array of Strings | Name of others containers in the same job that this container depends on
| containers[].devices[] | N | Array of Strings | Host devices to add to the container
| containers[].disable_content_trust | N | Boolean | Skip image verification
| containers[].dns[] | N | Array of Strings | DNS servers to add to the container
| containers[].dns_options[] | N | Array of Strings | DNS options to add to the container
| containers[].dns_search[] | N | Array of Strings | DNS search domains to add to the container
| containers[].entrypoint | N | String | Entrypoint for the container (only if you want to override the default entrypoint set by the image)
| containers[].env_file | N | Array of Strings | Paths of files containing environment variables to pass to the container
| containers[].env_vars[] | N | Array of Strings | Environment variables to pass to the container
| containers[].expose_ports[] | N | Array of Strings | Network ports to expose from the container without publishing it to your host
| containers[].group_adds[] | N | Array of Strings | Groups to join
| containers[].hostname | N | String | Container host name
| containers[].kernel_memory | N | String | Kernel memory limit
| containers[].labels[] | N | Array of Strings | Labels meta data
| containers[].links[] | N | Array of Strings | Links to others containers in the same job (name:alias)
| containers[].log_driver | N | String | Log driver for the container
| containers[].log_options[] | N | Array of Strings | Log driver options
| containers[].lxc_options[] | N | Array of Strings | LXC options
| containers[].mac_address | N | String  | Container MAC address
| containers[].memory | N | String | Memory limit to assign to the container (format: <number><optional unit>, where unit = b, k, m or g)
| containers[].memory_reservation | N | String | Memory soft limit to assign to the container (format: <number><optional unit>, where unit = b, k, m or g)
| containers[].memory_swap | N | String | Total memory usage (memory + swap), set '-1' to disable swap (format: <number><optional unit>, where unit = b, k, m or g)
| containers[].memory_swappiness | N | String | Memory swappiness
| containers[].net | N | String | Container network strategy, possible values are bridge (default), none (no network), host (use host network)
| containers[].oom_kill_disable | N | Boolean | Disable OOM Killer
| containers[].privileged | N | Boolean | Enable/disable extended privileges to this container
| containers[].bind_ports[] | N | Array of Strings | Network ports to map from the container to the host
| containers[].read_only | N | Boolean | Mount the container's root filesystem as read only
| containers[].restart | N | String | Restart policy to apply when a container exits (no, on-failure, always)
| containers[].ecurity_options[] | N | Array of Strings | Security options
| containers[].stop_signal | N | String | Signal to stop a container, SIGTERM by default
| containers[].ulimits[] | N | Array of Strings | Ulimit options
| containers[].user | N | String | Username or UID to run the first container process
| containers[].volumes[] | N | Array of Strings | Volumes to bind mount
| containers[].bind_volumes[] | N | Array of Strings | Volume mountpoints to bind to a host directory (provided automatically by CF-BOSH)
| containers[].volumes_from[]  | N | Array of Strings | Mount volumes from the specified container(s)
| containers[].volume_driver | N | String | Volume driver for the container
| containers[].workdir | N | String | Working directory inside the container
