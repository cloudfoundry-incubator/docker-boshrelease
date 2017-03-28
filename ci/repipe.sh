#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

set -e

echo fetching credentials
spruce --concourse merge pipeline.yml creds.yml > pipeline-deploy.yml

cd $DIR/..
fly -t vsphere sp -p $(basename $(pwd)) -c ci/pipeline-deploy.yml
rm ci/pipeline-deploy.yml
