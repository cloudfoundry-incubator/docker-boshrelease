* only require tls certs if `docker.tcp_address` is not `127.0.0.1` (the current default) [see [conversation](https://github.com/cloudfoundry-community/docker-boshrelease/commit/0f8c49204f926cd300ac7c59c305dfbf4e2eb324#commitcomment-25484535)]

    Added operator file to disable external docker access and the need for TLS certs:

    ```
    bosh deploy manifests/containers/example.yml -o manifests/op-disable-remote-docker-access.yml
    ```

* fix bug in `containers` job's `job_properties.sh.erb` templates
