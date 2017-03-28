#!/bin/bash

set -e # fail fast
set -x # print commands

OUTPUT="$PWD/candidate-release"
VERSION="$(cat version/number)"
RELEASE_NAME=${RELEASE_NAME:-docker-boshrelease}

cd boshrelease

bosh2 -n create-release --tarball=$OUTPUT/$RELEASE_NAME-$VERSION.tgz --force --name $RELEASE_NAME --version "$VERSION"
