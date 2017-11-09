#!/bin/bash

# The base manifests/redis.yml assumes that your `bosh cloud-config` contains
# "vm_type" and "networks" named "default". Its quite possible you don't have this.
# This script will select the first "vm_types" and first "networks" to use in
# your deployment. It will print to stderr the choices it made.
#
# Usage:
#   bosh deploy manifests/redis.yml -o <(./manifests/operators/pick-from-cloud-config.sh)

: ${BOSH_ENVIRONMENT:?required}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

instance_groups=$(bosh int $@ --path /instance_groups | grep "^  name:" | awk '{print $2}' | sort | uniq)
cloud_config=$(bosh cloud-config)
if [[ -z ${cloud_config} ]]; then
  echo "BOSH env missing a cloud-config"
  exit 1
fi
vm_type=$(bosh int <(echo "$cloud_config") --path /vm_types/0/name)
network=$(bosh int <(echo "$cloud_config") --path /networks/0/name)

>&2 echo "vm_type: ${vm_type}, network: ${network}"

for ig in $instance_groups; do
cat <<YAML
- type: replace
  path: /instance_groups/name=${ig}/networks/name=default/name
  value: ${network}

- type: replace
  path: /instance_groups/name=${ig}/vm_type
  value: ${vm_type}

YAML
done
