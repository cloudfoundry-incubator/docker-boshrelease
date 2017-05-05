#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

set -e

echo fetching credentials
spruce merge pipeline.yml creds.yml > pipeline-deploy.yml

cd $DIR/..
fly -t snw sp -p $(basename $(pwd)) -c ci/pipeline-deploy.yml
rm ci/pipeline-deploy.yml
