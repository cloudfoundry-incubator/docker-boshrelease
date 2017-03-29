#!/bin/bash

export BOSH_ENVIRONMENT=${BOSH_ENVIRONMENT:?required}
export BOSH_CA_CERT=${BOSH_CA_CERT:?required}
export BOSH_CLIENT=${BOSH_CLIENT:?required}
export BOSH_CLIENT_SECRET=${BOSH_CLIENT_SECRET:?required}
export BOSH_DEPLOYMENT=${BOSH_DEPLOYMENT:?required}

bosh2 run-errand ${errand:?required}
