#!/bin/bash

set -e

NOTES=$PWD/release-notes

release_version=$(cat version/number)
release_sha1=$(sha1sum final-release-tarball/*.tgz | head -n1 | awk '{print $1}')

echo v${release_version} > $NOTES/release-name

cat > $NOTES/notes.md <<EOF
## Improvements

TODO

## Deployment

Deployment manifest snippet:

\`\`\`yaml
releases:
- name: docker
  version: ${release_version}
  url: https://github.com/cloudfoundry-community/docker-boshrelease/releases/download/v${release_version}/docker-${release_version}.tgz
  sha1: ${release_sha1}
\`\`\`

Or \`bosh2\` operator patch file:

\`\`\`yaml
- type: replace
  path: /releases/name=docker
  value:
    version: ${release_version}
    url: https://github.com/cloudfoundry-community/docker-boshrelease/releases/download/v${release_version}/docker-${release_version}.tgz
    sha1: ${release_sha1}
\`\`\`

EOF
