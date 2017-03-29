#!/bin/bash

set -e

VERSION=$(cat version/number)
RELEASE_NAME=${RELEASE_NAME:-"dingo-postgresql"}

FINAL_RELEASE_TARBALL=$PWD/final-release-tarball
FINAL_RELEASE_REPO=$PWD/final-release-repo

CANDIDATE_DIR=$PWD/candidate-release

git clone boshrelease $FINAL_RELEASE_REPO
cd $FINAL_RELEASE_REPO

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

RELEASE_YML=$PWD/releases/${RELEASE_NAME}/${RELEASE_NAME}-${VERSION}.yml
RELEASE_TGZ=$PWD/releases/${RELEASE_NAME}/${RELEASE_NAME}-${VERSION}.tgz

if [ -e ${RELEASE_YML} ]; then
  echo "release already created from previous job; making tarball..."
  bosh -n create release --with-tarball ${RELEASE_YML}
else
  echo "finalizing release"
  bosh2 -n finalize-release --version "$VERSION" ${CANDIDATE_DIR}/${RELEASE_NAME}-*.tgz
  git add -A
  git commit -m "release v${VERSION}"
fi

mv ${RELEASE_TGZ} ${FINAL_RELEASE_TARBALL}
