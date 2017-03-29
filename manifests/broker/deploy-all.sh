#!/bin/bash

# USAGE:
#   ./manifests/broker/deploy-all.sh --vars-store tmp/creds.yml
#   ./manifests/broker/deploy-all.sh \
#     -o manifests/broker/op-cf-integration.yml \
#     -l tmp/vars-cf-lite49.yml -o manifests/op-public-tls.yml \
#     -o manifests/broker/op-external-host.yml \
#     --vars-store tmp/creds.yml
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

op_files=""

cd services
for service in $(ls -1 *); do
  op_files="$op_files -o manifests/broker/services/$service "
done

cd ../../..

export BOSH_DEPLOYMENT=${BOSH_DEPLOYMENT:-docker-broker}
cat > tmp/deploy-all-name.yml <<YAML
---
- type: replace
  path: /name
  value: ${BOSH_DEPLOYMENT}
YAML

set -x
bosh2 deploy manifests/broker/docker-broker.yml \
  -o tmp/deploy-all-name.yml \
  $op_files \
  $@
