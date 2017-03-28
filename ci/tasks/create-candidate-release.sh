#!/bin/bash

set -e # fail fast
set -x # print commands

OUTPUT="$PWD/candidate-release"
release_version="$(cat version/number)"
release_name=${release_name:-docker}

cd boshrelease

bosh2 -n create-release --tarball=$OUTPUT/$release_name-$release_version.tgz --force --name $release_name --version "$release_version"
