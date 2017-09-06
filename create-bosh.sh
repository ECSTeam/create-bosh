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

git clone https://github.com/cloudfoundry/bosh-deployment.git

IaaS=iaas.json
DIRECTOR_NAME=`cat $IaaS | jq -r '.director_name.value'`
INTERNAL_CIDR=`cat $IaaS | jq -r '.private_subnet_cidr.value'`
INTERNAL_GW=`cat $IaaS | jq -r '.internal_gateway.value'`
INTERNAL_IP=`cat $IaaS | jq -r '.director_ip.value'`
NETWORK_NAME=`cat $IaaS | jq -r '.private_subnet_id.value'`
VCENTER_DC=`cat $IaaS | jq -r '.region.value'`
VCENTER_DS=`cat $IaaS | jq -r '.datastore.value'`
VCENTER_IP=`cat $IaaS | jq -r '.iaas_endpoint.value'`
INTERNAL_DNS=`cat $IaaS | jq -r '.iaas_dns.value'`
VCENTER_USER="lab09admin@lab.ecsteam.local"
VCENTER_PASSWORD="Ecsl@b99"
VCENTER_TEMPLATES=`cat $IaaS | jq -r '.iaas_image_location.value'`
VCENTER_VMS=`cat $IaaS | jq -r '.iaas_image.value'`
VCENTER_DISKS=`cat $IaaS | jq -r '.iaas_disk.value'`
VCENTER_CLUSTER=`cat $IaaS | jq -r '.iaas_cluster.value'`


if [ $command == "vsphere" ]; then
  bosh2 create-env $BD/bosh.yml \
    --state=bosh-init-state.json \
    --vars-store=./creds.yml \
    -o $BD/vsphere/cpi.yml \
    -o $BD/misc/dns.yml \
    -v director_name=$DIRECTOR_NAME \
    -v internal_cidr=$INTERNAL_CIDR \
    -v internal_gw=$INTERNAL_GW \
    -v internal_ip=$INTERNAL_IP \
    -v network_name=$NETWORK_NAME \
    -v vcenter_dc=$VCENTER_DC \
    -v vcenter_ds=$VCENTER_DS \
    -v vcenter_ip=$VCENTER_IP \
    -v internal_dns=$INTERNAL_DNS \
    -v vcenter_user=$VCENTER_USER \
    -v vcenter_password=$VCENTER_PASSWORD \
    -v vcenter_templates=$VCENTER_TEMPLATES \
    -v vcenter_vms=$VCENTER_VMS \
    -v vcenter_disks=$VCENTER_DISKS \
    -v vcenter_cluster=$VCENTER_CLUSTER
fi

bosh2 -e 172.28.98.50 --ca-cert <(bosh2 int ./creds.yml --path /director_ssl/ca) alias-env lab09
