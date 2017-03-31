#!/usr/bin/env bash

# Setup env vars and folders for the ctl script
# This helps keep the ctl script as readable
# as possible

# Usage options:
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh JOB_NAME OUTPUT_LABEL
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar nginx

set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

JOB_NAME=$1
output_label=${2:-${JOB_NAME}}

export JOB_DIR=/var/vcap/jobs/$JOB_NAME
chmod 755 $JOB_DIR # to access file via symlink

source $JOB_DIR/helpers/ctl_utils.sh

# Setup the PATH and LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-''} # default to empty
for package_dir in $(ls -d /var/vcap/packages/*)
do
  has_busybox=0
	# Add all packages' /bin & /sbin into $PATH
  for package_bin_dir in $(ls -d ${package_dir}/*bin)
  do
    # Do not add any packages that use busybox, as impacts builtin commands and
    # is often used for different architecture (via containers)
    if [ -f ${package_bin_dir}/busybox ]
    then
      has_busybox=1
    else
      export PATH=${package_bin_dir}:$PATH
    fi
  done
  if [ "$has_busybox" == "0" ] && [ -d ${package_dir}/lib ]
  then
    export LD_LIBRARY_PATH=${package_dir}/lib:$LD_LIBRARY_PATH
  fi
done

# Setup log, run and tmp folders

export RUN_DIR=/var/vcap/sys/run/$JOB_NAME
export LOG_DIR=/var/vcap/sys/log/$JOB_NAME
export TMP_DIR=/var/vcap/sys/tmp/$JOB_NAME
export STORE_DIR=/var/vcap/store/$JOB_NAME
for dir in $RUN_DIR $LOG_DIR $TMP_DIR $STORE_DIR
do
  mkdir -p ${dir}
  chown vcap:vcap ${dir}
  chmod 775 ${dir}
done
export TMPDIR=$TMP_DIR

export C_INCLUDE_PATH=/var/vcap/packages/mysqlclient/include/mysql:/var/vcap/packages/sqlite/include:/var/vcap/packages/libpq/include
export LIBRARY_PATH=/var/vcap/packages/mysqlclient/lib/mysql:/var/vcap/packages/sqlite/lib:/var/vcap/packages/libpq/lib

echo '$PATH' $PATH
