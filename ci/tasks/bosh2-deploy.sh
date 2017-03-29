#!/bin/bash

set -e

manifest_dir=$(pwd)/manifest

export BOSH_ENVIRONMENT=${BOSH_ENVIRONMENT:?required}
export BOSH_CA_CERT=${BOSH_CA_CERT:?required}
export BOSH_CLIENT=${BOSH_CLIENT:?required}
export BOSH_CLIENT_SECRET=${BOSH_CLIENT_SECRET:?required}
export BOSH_DEPLOYMENT=${BOSH_DEPLOYMENT:?required}
release_version="$(cat version/number)"

if [[ "${delete_deployment_first:-false}" != "false" ]]; then
  bosh2 -n delete-deployment
fi

cd boshrelease-ci
release_name=$(bosh2 int config/final.yml --path /final_name)

mkdir -p tmp

cat > tmp/versions.yml <<YAML
---
- type: replace
  path: /releases/name=${release_name}/version
  value: ${release_version}
YAML

cat > tmp/deployment.yml <<YAML
---
- type: replace
  path: /name
  value: ${BOSH_DEPLOYMENT:?required}
YAML

cat > tmp/vars.yml <<YAML
---
cf_api_url: ${cf_api_url:-}
cf_skip_ssl_validation: ${cf_skip_ssl_validation:-}
cf_admin_username: ${cf_admin_username:-}
cf_admin_password: ${cf_admin_password:-}
broker_route_name: ${BOSH_DEPLOYMENT}
broker_route_uri: ${BOSH_DEPLOYMENT}.${cf_system_domain}
YAML

op_patch_files_flags=""
for op_patch_file in ${op_patch_files//,/ } ; do
   op_patch_files_flags="${op_patch_files_flags} -o $op_patch_file"
done

set -x
bosh2 int ${base_manifest:?required} \
  -o           manifests/op-dev.yml  \
  -o           tmp/deployment.yml    \
  -o           tmp/versions.yml      \
  ${op_patch_files_flags}            \
  --vars-store tmp/creds.yml \
  --vars-file  tmp/vars.yml  \
  --var-errs \
    > $manifest_dir/manifest.yml

bosh2 -n deploy $manifest_dir/manifest.yml

if [[ "${test_errand:-X}" != "X" ]]; then
  bosh2 run-errand ${test_errand}
fi
