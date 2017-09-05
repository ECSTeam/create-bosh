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
