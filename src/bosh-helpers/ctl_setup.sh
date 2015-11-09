#!/usr/bin/env bash

# Setup env vars and folders for the ctl script
# This helps keep the ctl script as readable as possible

# Usage options:
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh JOB_NAME OUTPUT_LABEL
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar nginx

set -e # exit immediately if a simple command exits with a non-zero status

export JOB_NAME=$1
export OUTPUT_LABEL=${2:-$JOB_NAME}

# Setup job home folder
export HOME=/var/vcap
export JOB_DIR=$HOME/jobs/$JOB_NAME

# Setup log, run, store and tmp folders
export LOG_DIR=$HOME/sys/log/$JOB_NAME
export RUN_DIR=$HOME/sys/run/$JOB_NAME
export STORE_DIR=$HOME/store/$JOB_NAME
export TMP_DIR=$HOME/sys/tmp/$JOB_NAME
export TMPDIR=$TMP_DIR
for dir in $LOG_DIR $RUN_DIR $STORE_DIR $TMP_DIR
do
  mkdir -p ${dir}
  chown vcap:vcap ${dir}
  chmod 775 ${dir}
done

# Load job properties
if [ -f $JOB_DIR/bin/job_properties.sh ]; then
  source $JOB_DIR/bin/job_properties.sh
fi

# Load some control helpers
source $HOME/packages/bosh-helpers/ctl_utils.sh

# Redirect output
redirect_output ${OUTPUT_LABEL}
