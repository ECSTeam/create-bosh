#!/bin/bash
########################################################
#
#  This script configures the environment to target
#  a given BOSH instance. This is intended to be copied
#  to the deployment artifacts directory and sourced into
#  the current shell. i.e. > source set-bosh-env.sh
#
#########################################################

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh2 int ./creds.yml --path /admin_password`
bosh2 -e <bosh ip/hostname> --ca-cert <(bosh2 int ./creds.yml --path /director_ssl/ca) alias-env <env-alias>

export BOSH_ENVIRONMENT=<env-alias>
