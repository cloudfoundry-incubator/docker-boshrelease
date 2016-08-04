#!/bin/sh
# USAGE monit_debugger <label> command to run
mkdir -p /var/vcap/sys/log/monit
{
  echo "MONIT-DEBUG date"
  date
  echo "MONIT-DEBUG env"
  env
  echo "MONIT-DEBUG $@"
  $2 $3 $4 $5 $6 $7
  R=$?
  echo "MONIT-DEBUG exit code $R"
} >/var/vcap/sys/log/monit/monit_debugger.$1.log 2>&1
