#!/bin/bash

set -e # fail fast
set -x # print commands

OUTPUT="$PWD/candidate-release"
release_version="$(cat version/number)"

cd boshrelease
release_name=$(bosh2 int config/final.yml --path /final_name)

bosh2 -n create-release --tarball=$OUTPUT/$release_name-$release_version.tgz --force --name $release_name --version "$release_version"
