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
   create-bosh.sh -i <IAAS> \
     -o <operational config file> -u <IAAS user> -p <IAAS password>

Support IAASes - vsphere, gcp, azure, aws
EOF
}

####################################
#
#   MAIN
#
####################################
BD=bosh-deployment

# IAAS to create BOSH on.
IAAS=""

# Operational configuration file
OPS_CONFIG=""

# IAAS credentials
IAAS_USER=""
IAAS_PW=""

# A POSIX variable
OPTIND=1

while getopts "ho:p:u:i:" opt; do
    case "$opt" in
    h|\?)
        usage
        exit 0
        ;;
    i)
        IAAS=$OPTARG
        ;;
    o)
        OPS_CONFIG=$OPTARG
        ;;
    u)
        IAAS_USER=$OPTARG
        ;;
    p)
        IAAS_PW=$OPTARG
        ;;
    *)
        echo "Unknown argument - $opt"
        usage
        exit 1
        ;;
    esac
done

shift $((OPTIND-1))

git clone https://github.com/cloudfoundry/bosh-deployment.git

DIRECTOR_NAME=`cat $OPS_CONFIG | jq -r '.director_name.value'`
INTERNAL_CIDR=`cat $OPS_CONFIG | jq -r '.private_subnet_cidr.value'`
INTERNAL_GW=`cat $OPS_CONFIG | jq -r '.internal_gateway.value'`
INTERNAL_IP=`cat $OPS_CONFIG | jq -r '.director_ip.value'`
NETWORK_NAME=`cat $OPS_CONFIG | jq -r '.private_subnet_id.value'`
VCENTER_DC=`cat $OPS_CONFIG | jq -r '.region.value'`
VCENTER_DS=`cat $OPS_CONFIG | jq -r '.datastore.value'`
VCENTER_IP=`cat $OPS_CONFIG | jq -r '.iaas_endpoint.value'`
INTERNAL_DNS=`cat $OPS_CONFIG | jq -r '.iaas_dns.value'`
VCENTER_USER=$IAAS_USER
VCENTER_PASSWORD=$IAAS_PW
VCENTER_TEMPLATES=`cat $OPS_CONFIG | jq -r '.iaas_image_location.value'`
VCENTER_VMS=`cat $OPS_CONFIG | jq -r '.iaas_image.value'`
VCENTER_DISKS=`cat $OPS_CONFIG | jq -r '.iaas_disk.value'`
VCENTER_CLUSTER=`cat $OPS_CONFIG | jq -r '.iaas_cluster.value'`


if [ $IAAS == "vsphere" ]; then
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

bosh2 -e 172.28.98.50 --ca-cert <(bosh2 int ./creds.yml --path /director_ssl/ca) alias-env bootstrap
