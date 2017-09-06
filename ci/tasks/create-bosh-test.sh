#!/bin/bash -e

set -x

EXPECTED_HELP="USAGE:
   create-bosh.sh <IaaS>

Support IaaSes - vsphere, gcp, azure, aws"

ACTUAL_HELP=`create-bosh/create-bosh.sh help`

# Fail test if help message is not as expected.
if [[ $ACTUAL_HELP != $EXPECTED_HELP ]]; then
  echo "Unexpected help message : $ACTUAL_HELP"
  exit 1
fi

create-bosh/create-bosh.sh vsphere

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh2 int create-bosh/creds.yml --path /admin_password`

bosh2 -e lab09 l

# create-bosh/cleanup.sh vsphere

# verify bosh is deleted with some command
