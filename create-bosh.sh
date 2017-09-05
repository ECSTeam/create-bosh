#!/bin/bash -e
###############################################################
#
# Create a BOSH environment based on the given parameters.
#
###############################################################

set -x

function usage() {
cat <<EOF
USAGE:
   create-bosh.sh <IaaS>

Support IaaSes - vsphere, gcp, azure, aws
EOF
}

####################################
#
#   MAIN
#
####################################
BD=bosh-deployment

command=$1

if [ -z $command ] ; then
	usage
	exit 1
fi

if [ $command == "help" ]; then
  usage
  exit 0
fi

git -c http.sslVerify=false clone git@github.com:cloudfoundry/bosh-deployment.git

if [ $command == "vsphere" ]; then
  bosh2 create-env $BD/bosh.yml \
    --state=bosh-init-state.json \
    --vars-store=./creds.yml \
    -o $BD/vsphere/cpi.yml \
    -o $BD/misc/dns.yml \
    -v director_name=steve-wall-cgi-class \
    -v internal_cidr=172.28.98.0/24 \
    -v internal_gw=172.28.98.1 \
    -v internal_ip=172.28.98.50 \
    -v network_name="Lab09-NetH" \
    -v vcenter_dc=Lab09-Datacenter01 \
    -v vcenter_ds=nfs-lab09-vol1 \
    -v vcenter_ip=172.29.0.11 \
    -v internal_dns=[172.29.0.5] \
    -v vcenter_user="lab09admin@lab.ecsteam.local" \
    -v vcenter_password="Ecsl@b99" \
    -v vcenter_templates=steve-wall-bosh-templates \
    -v vcenter_vms=steve-wall-bosh-vms \
    -v vcenter_disks=steve-wall-bosh-disks \
    -v vcenter_cluster=Lab09-Cluster01
fi

bosh2 -e 172.28.98.50 --ca-cert <(bosh2 int ./creds.yml --path /director_ssl/ca) alias-env lab09
