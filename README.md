# Bosh release for Docker

One of the fastest ways to get [Docker](https://www.docker.io/) and orchestrate containers with persistent data on any
infrastructure is to deploy this BOSH release.

## Disclaimer

This is not presently a production ready [Docker](https://www.docker.io/) BOSH release. This is a work in progress.
It is suitable for experimentation and may not become supported in the future.


This BOSH release needs a [BOSH stemcell](http://bosh_artifacts.cfapps.io/file_collections?type=stemcells) with a
embedded Linux kernel >= 3.8, so be sure to use one of the public stemcells that come with Ubuntu Trusty.

## Usage

### Upload the BOSH release

To use this BOSH release, first upload it to your BOSH:

```
bosh target BOSH_HOST
git clone https://github.com/cf-platform-eng/docker-boshrelease.git
cd docker-boshrelease
bosh upload release releases/docker-9.yml
```

### Create a BOSH deployment manifest

There are to deployment scenarios for this BOSH release:

* Deploy statically defined Docker containers: see [CONTAINERS.md](https://github.com/cf-platform-eng/docker-boshrelease/blob/master/CONTAINERS.md) for deployment instructions.
* Deploy a Docker Service Broker for your Cloud Foundry deployment: see [SERVICE_BROKER.md](https://github.com/cf-platform-eng/docker-boshrelease/blob/master/SERVICE_BROKER.md) for deployment instructions.

### Deploy using the BOSH deployment manifest

Using the previous created deployment manifest, now we can deploy it:

```
bosh deployment path/to/deployment.yml
bosh -n deploy
```

### Troubleshooting

#### Proxy support

If your vms require a proxy in order to get internet access to fetch the Docker images,  you can set the proxy URIs
using the `env.http_proxy`, `env.https_proxy` and `env.no_proxy` properties at your deployment manifest.

#### DNS issues

One of the most frequent problems when deploying this BOSH release is that Docker is unable to fetch images from the
[Docker Hub Registry](https://registry.hub.docker.com/). This usually happens when the first DNS nameserver specified
at the `/etc/resolv.conf` file in the VM is unable to resolve the `index.docker.io` hostname. In order to fix this
issue the first DNS nameserver must be able to resolve external hostnames. Usually the first DNS nameserver is the
microBOSH [PowerDNS](https://www.powerdns.com/) IP address, so in order to fix this you must re-deploy microBOSH
setting a PowerDNS recursor. This can be done updating the `micro_bosh.yml` file with:

```
apply_spec:
  properties:
    dns:
      recursor: 8.8.8.8
```

#### Cloud Foundry Security Groups

Another issue may be that applications cannot connect to your Docker-based services and raise connection errors. The cause of this may be the new Cloud Foundry Security Groups. It is possible that the default security groups prevent access to the same network range that includes your Docker VM.

Fix the security groups when deploying Cloud Foundry itself via BOSH. Alternately, a quick and dirty solution if testing this BOSH release for the first time is to create an `everything` security group and bind it only to the space you are using now.

Create a temporary file `everything.json`:

```json
[
  {
    "destination": "0.0.0.0-255.255.255.255",
    "protocol": "all"
  }
]
```

Register the new security group, as an `admin` user:

```
cf create-security-group everything everything.json
```

Bind the security group to your current org/space:

```
cf bind-security-group everything ORG SPACE
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

### Create new release

#### Creating a development release

If you need to create a new development release, you will need to run the `./update` command first to download the
submodule bits.

Also, you will need [Ruby 2+](https://www.ruby-lang.org) and [bundler](http://bundler.io) installed at your
workstation in order to bundle all required gems and compile the assets.

#### Creating a final release

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
