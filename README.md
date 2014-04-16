# Bosh release for Docker

One of the fastest ways to get [Docker](https://www.docker.io/) and orchestrate containers with persistent data on any infrastructure is to deploy this BOSH release.

## Disclaimer

This is not presently a production ready [Docker](https://www.docker.io/) BOSH release. This is a work in progress.

This BOSH release needs a [BOSH stemcell](http://bosh_artifacts.cfapps.io/file_collections?type=stemcells) with a embedded Linux kernel >= 3.8. At this moment the official stemcells come with Linux kernel 3.0, so for your convenience here there are the links to some unofficial stemcells:

* AWS: [http://storage.googleapis.com/bosh-stemcells/bosh-stemcell-2005-aws-xen-ubuntu-3.8.tgz](http://storage.googleapis.com/bosh-stemcells/bosh-stemcell-2005-aws-xen-ubuntu-3.8.tgz)
* OpenStack: [http://storage.googleapis.com/bosh-stemcells/bosh-stemcell-2005-openstack-kvm-ubuntu-3.8.tgz](http://storage.googleapis.com/bosh-stemcells/bosh-stemcell-2005-openstack-kvm-ubuntu-3.8.tgz)
* VSphere: [http://storage.googleapis.com/bosh-stemcells/bosh-stemcell-2005-vsphere-esxi-ubuntu-3.8.tgz](http://storage.googleapis.com/bosh-stemcells/bosh-stemcell-2005-vsphere-esxi-ubuntu-3.8.tgz)
* GCE: [http://storage.googleapis.com/bosh-stemcells/light-bosh-stemcell-2005-google-kvm-ubuntu.tgz](http://storage.googleapis.com/bosh-stemcells/light-bosh-stemcell-2005-google-kvm-ubuntu.tgz)

## Usage

To use this BOSH release, first upload it to your BOSH:

```
bosh target BOSH_HOST
git clone https://github.com/cf-platform-eng/docker-boshrelease.git
cd docker-boshrelease
bosh upload release releases/docker-1.yml
```

Now create a deployment file (using the files at the [examples](https://github.com/cf-platform-eng/docker-boshrelease/tree/master/examples) directory as a starting point) and deploy:

```
vi path/to/deployment.yml
bosh deployment path/to/deployment.yml
bosh -n deploy
```

## Create new final release

To create a new final release you need to get read/write API credentials to the [@cloudfoundry-community](https://github.com/cloudfoundry-community) s3 account.

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
