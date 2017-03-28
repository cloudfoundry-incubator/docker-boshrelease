#!/bin/bash

set -e

: ${VAULT_PREFIX:?required}
: ${VAULT_ADDR:?required}

# safe -k target ci ${VAULT_TARGET:?required}
# echo ${GITHUB_TOKEN:?required} | safe auth github

echo "Logging in to Vault..."
vault auth -method=github token=${GITHUB_TOKEN:?required} > /dev/null

cat > director-creds.spruce.yml <<YAML
---
internal_ip: (( vault "$VAULT_PREFIX" "/env:ip" ))
admin_password: (( vault "$VAULT_PREFIX" "/users/admin:password" ))
director_ssl:
  ca: (( vault "$VAULT_PREFIX" "/certs:rootCA.pem" ))
YAML

echo "Creating director-state/director-creds.yml"
spruce merge director-creds.spruce.yml > director-state/director-creds.yml
