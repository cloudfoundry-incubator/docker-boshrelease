#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

release_yml=$PWD/releases/${release_name}/${release_name}-${release_version}.yml
if [ -e ${release_yml} ]; then
  echo "release already created from previous job; making tarball..."
else
  echo "finalizing release"
  bosh2 -n finalize-release --version "$release_version" ${CANDIDATE_DIR}/${release_name}-*.tgz

  git add -A
  git commit -m "release v${release_version}"
fi

final_release_tgz=${FINAL_RELEASE_TARBALL}/${release_name}-${release_version}.tgz
bosh2 create-release \
  --tarball ${final_release_tgz} ${release_yml}

$DIR/update-manifests-with-latest-release.sh $release_name $release_version $final_release_tgz
git add -A
git commit -m "update manifests for v${release_version}"
