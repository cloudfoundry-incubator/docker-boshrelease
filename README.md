# Docker deployed by BOSH

One of the fastest ways to get [Docker](https://www.docker.io/) and orchestrate containers with persistent data on any infrastructure is to deploy this BOSH release.

* [CI](https://ci.starkandwayne.com/teams/main/pipelines/docker-boshrelease)

## Examples

Run a static set of Docker containers, backed by a persistent disk:

![ctop-example](manifests/containers/ctop-example.png)

Allow users to dynamically provision persistent services, running in Docker containers, using the `cf` Cloud Foundry CLI:

![cf-create-service-ctop](manifests/broker/cf-create-service-ctop.gif)

And example usage is MySQL 5.6: each provisioned service is running inside a dedicated Docker container. The service provides credentials that look like:

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
