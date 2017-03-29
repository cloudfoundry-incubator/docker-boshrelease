#!/bin/bash

set -e

release_version=$(cat version/number)

FINAL_RELEASE_TARBALL=$PWD/final-release-tarball
FINAL_RELEASE_REPO=$PWD/final-release-repo

CANDIDATE_DIR=$PWD/candidate-release

git clone boshrelease $FINAL_RELEASE_REPO
cd $FINAL_RELEASE_REPO

release_name=$(bosh2 int config/final.yml --path /final_name)

cat > config/private.yml << EOF
---
blobstore:
  provider: s3
  options:
    access_key_id: ${aws_access_key_id}
    secret_access_key: ${aws_secret_access_key}
EOF

if [[ -z "$(git config --global user.name)" ]]
then
  git config --global user.name "Concourse Bot"
  git config --global user.email "drnic+bot@starkandwayne.com"
fi

RELEASE_YML=$PWD/releases/${release_name}/${release_name}-${release_version}.yml
RELEASE_TGZ=$PWD/releases/${release_name}/${release_name}-${release_version}.tgz

if [ -e ${RELEASE_YML} ]; then
  echo "release already created from previous job; making tarball..."
  bosh -n create release --with-tarball ${RELEASE_YML}
else
  echo "finalizing release"
  bosh2 -n finalize-release --version "$release_version" ${CANDIDATE_DIR}/${release_name}-*.tgz
  git add -A
  git commit -m "release v${release_version}"
fi

mv ${RELEASE_TGZ} ${FINAL_RELEASE_TARBALL}
