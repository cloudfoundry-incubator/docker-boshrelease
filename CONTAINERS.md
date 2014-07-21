# Deploy statically defined Docker containers

In this scenario you can deploy Docker containers statically defined at your deployment manifest.

See [Managing Stateful Docker Containers with Cloud Foundry BOSH](http://blog.pivotal.io/cloud-foundry-pivotal/products/managing-stateful-docker-containers-with-cloud-foundry-bosh) for more details.

## Example

Create a deployment file using as a starting point one the files `docker-<Iaas>.yml` located at the
[examples](https://github.com/cf-platform-eng/docker-boshrelease/tree/master/examples) directory:

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

<table>
  <tr>
    <th>Field</th>
    <th>Required</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>containers[]</td>
    <td>Y</td>
    <td>Array</td>
    <td>Containers to deploy</td>
  </tr>
  <tr>
    <td>containers[].name</td>
    <td>Y</td>
    <td>String</td>
    <td>Name to assign to the container</td>
  </tr>
  <tr>
    <td>containers[].image</td>
    <td>Y</td>
    <td>String</td>
    <td>Name of the image to create or the image fo fetch and run from the registry</td>
  </tr>
  <tr>
    <td>containers[].dockerfile</td>
    <td>N</td>
    <td>String (Literal Style)</td>
    <td>Contents of the Dockerfile (when you want to build a Docker image)</td>
  </tr>
  <tr>
    <td>containers[].command</td>
    <td>N</td>
    <td>String</td>
    <td>Command to the run the container (including arguments)</td>
  </tr>
  <tr>
    <td>containers[].entrypoint</td>
    <td>N</td>
    <td>String</td>
    <td>Entrypoint for the container (only if you want to override the default entrypoint set by the image)</td>
  </tr>
  <tr>
    <td>containers[].workdir</td>
    <td>N</td>
    <td>String</td>
    <td>Working directory inside the container</td>
  </tr>
  <tr>
    <td>containers[].expose_ports[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Network ports to expose from the container without publishing it to your host</td>
  </tr>
  <tr>
    <td>containers[].bind_ports[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Network ports to map from the container to the host</td>
  </tr>
  <tr>
    <td>containers[].volumes[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Volumes to bind mount</td>
  </tr>
  <tr>
    <td>containers[].bind_volumes[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Volume mountpoints to bind to a host directory (provided automatically by CF-BOSH)</td>
  </tr>
  <tr>
    <td>containers[].volumes_from[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Mount volumes from the specified container(s)</td>
  </tr>
  <tr>
    <td>containers[].links[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Links to others containers in the same job (name:alias)</td>
  </tr>
  <tr>
    <td>containers[].depends_on[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Name of others containers in the same job that this container depends on</td>
  </tr>
  <tr>
    <td>containers[].env_vars[]</td>
    <td>N</td>
    <td>Array of Strings</td>
    <td>Environment variables to pass to the container</td>
  </tr>
  <tr>
    <td>containers[].user</td>
    <td>N</td>
    <td>String</td>
    <td>Username or UID to run the first container process</td>
  </tr>
  <tr>
    <td>containers[].cpu_shares</td>
    <td>N</td>
    <td>String</td>
    <td>CPU shares to assign to the container (relative weight)</td>
  </tr>
  <tr>
    <td>containers[].memory</td>
    <td>N</td>
    <td>String</td>
    <td>Memory limit to assign to the container (format: <number><optional unit>, where unit = b, k, m or g)</td>
  </tr>
  <tr>
    <td>containers[].privileged</td>
    <td>N</td>
    <td>Boolean</td>
    <td>Enable/disable extended privileges to this container</td>
  </tr>
</table>
