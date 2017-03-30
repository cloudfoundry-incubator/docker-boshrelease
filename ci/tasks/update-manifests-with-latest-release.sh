#!/bin/bash

name=$1
version=$2
final_release_tgz=$3
: ${final_release_tgz:?USAGE: name version tgz}

sha1=$(sha1sum $final_release_tgz | awk '{print $1}')

manifests=(containers/example.yml broker/docker-broker.yml swarm/docker-swarm.yml)
for manifest in ${manifests[@]}; do
  manifest_path=manifests/$manifest
  manifest_len=$(wc -l $manifest_path | awk '{print $1}')
  manifest_head=$(head -n `expr $manifest_len - 4` $manifest_path)
  cat > $manifest_path <<YAML
${manifest_head}
- name: $name
  version: $version
  url: https://github.com/cloudfoundry-community/docker-boshrelease/releases/download/v${version}/${name}-${version}.tgz
  sha1: $sha1
YAML
done
