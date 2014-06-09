# Bosh release for Docker

One of the fastest ways to get [Docker](https://www.docker.io/) and orchestrate containers with persistent data on any infrastructure is to deploy this BOSH release.

## Disclaimer

This is not presently a production ready [Docker](https://www.docker.io/) BOSH release. This is a work in progress.

This BOSH release needs a [BOSH stemcell](http://bosh_artifacts.cfapps.io/file_collections?type=stemcells) with a embedded Linux kernel >= 3.8, so be sure to use one of the public stemcells that come with Ubuntu Trusty.

## Usage

### Upload the BOSH release

To use this BOSH release, first upload it to your BOSH:

```
bosh target BOSH_HOST
git clone https://github.com/cf-platform-eng/docker-boshrelease.git
cd docker-boshrelease
bosh upload release releases/docker-4.yml
```

### Create a BOSH deployment manifest

Now create a deployment file (using the files at the [examples](https://github.com/cf-platform-eng/docker-boshrelease/tree/master/examples) directory as a starting point) and deploy:

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

### Properties format

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

### Deploy using the BOSH deployment manifest

Using the previous created deployment manifest, now we can deploy it:

```
bosh deployment path/to/deployment.yml
bosh -n deploy
```

## Contributing

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by closing [issues](https://github.com/cf-platform-eng/docker-boshrelease/issues)
* by reviewing patches


### Submitting an Issue
We use the [GitHub issue tracker](https://github.com/cf-platform-eng/docker-boshrelease/issues) to track bugs and features.
Before submitting a bug report or feature request, check to make sure it hasn't already been submitted. You can indicate
support for an existing issue by voting it up. When submitting a bug report, please include a
[Gist](http://gist.github.com/) that includes a stack trace and any details that may be necessary to reproduce the bug,
including your gem version, Ruby version, and operating system. Ideally, a bug report should include a pull request with
 failing specs.


### Submitting a Pull Request

1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Commit and push your changes.
5. Submit a pull request.

### Create new final release

If you need to create a new final release, you will need to get read/write API credentials to the [@cloudfoundry-community](https://github.com/cloudfoundry-community) s3 account.

Please email [Dr Nic Williams](mailto:&#x64;&#x72;&#x6E;&#x69;&#x63;&#x77;&#x69;&#x6C;&#x6C;&#x69;&#x61;&#x6D;&#x73;&#x40;&#x67;&#x6D;&#x61;&#x69;&#x6C;&#x2E;&#x63;&#x6F;&#x6D;) and he will create unique API credentials for you.

Create a `config/private.yml` file with the following contents:

``` yaml
---
blobstore:
  s3:
    access_key_id:     ACCESS
    secret_access_key: PRIVATE
```

You can now create final releases for everyone to enjoy!

```
bosh create release
# test this dev release
git commit -m "updated docker"
bosh create release --final
git commit -m "creating vXYZ release"
git tag vXYZ
git push origin master --tags
```

## Copyright

See [LICENSE](https://github.com/cf-platform-eng/docker-boshrelease/blob/master/LICENSE) for details.
Copyright (c) 2014 [Pivotal Software, Inc](http://www.gopivotal.com/).
