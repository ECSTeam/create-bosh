#!/bin/bash -e
###############################################################
#
# Creates a BOSH environment based on the given parameters.
#
# It is expected a cloud-config.yml and iaas.json exist in the configuration
# directory.
#
# Arguments:
#     -c <config directory> - The directory where configuration files
#        are stored.
#     -o <deployment directory> - The directory where needed
#         deployment files live and where gerenated files are stored.
#         The thought is, this directory would be persisted in an
#         object store or github.
#     -i <IaaS> - the IaaS BOSH will be deployed to.
#     -u <IaaS user> - IaaS user with permissions to perform a deployment.
#     -p <IaaS password> - password for the IaaS user.
#     -d - flag set to delete the deployment.
#
###############################################################

# Exit with a failure if a command fails.
set -e

function usage() {
cat <<EOF
USAGE:
   create-bosh.sh -c <config directory> -o <deployment directory> -i <IAAS> -u <IAAS user> -p <IAAS password> [-d]

-d - delete the current deployment

Supported IaaSes - vsphere, gcp, azure, aws
EOF
}

function create_aws() {
    # aws specific properties
    DEFAULT_KEY_NAME=`cat $OPS_CONFIG | jq -r '.key_pair_name.value'`
    DEFAULT_SECURITY_GROUPS=`cat $OPS_CONFIG | jq -r '.default_security_group.value'`
    AZ=`cat $OPS_CONFIG | jq -r '.az.value'`
    REGION=`cat $OPS_CONFIG | jq -r '.region.value'`
    SUBNET_ID=`cat $OPS_CONFIG | jq -r '.subnet_id.value'`
    PRIVATE_KEY_FILE=`cat $OPS_CONFIG | jq -r '.private_key_file.value'`
    DIRECTOR_EXTERNAL_IP=`cat $OPS_CONFIG | jq -r '.director_public_ip.value'`

    if [ -z $POSTGRES_PASSWORD ]; then
    echo "using default password for postgres_password"
    POSTGRES_PASSWORD=postgres_password
    fi
    if [ -z $REGISTRY_PASSWORD ]; then
    echo "using default password for registry_password"
    REGISTRY_PASSWORD=registry_password
    fi

    bosh2 $ACTION $BD/bosh.yml \
        --state=$DEPLOYMENT_DIR/bosh-init-state.json \
        --vars-store=$DEPLOYMENT_DIR/creds.yml \
        -o $BD/aws/cpi.yml \
        -v director_name=$DIRECTOR_NAME \
        -v internal_cidr=$INTERNAL_CIDR \
        -v internal_gw=$INTERNAL_GW \
        -v internal_ip=$INTERNAL_IP \
        -v access_key_id=$IAAS_USER \
        -v secret_access_key=$IAAS_PASSWORD \
        -v region=$REGION \
        -v az=$AZ \
        -v default_key_name=$DEFAULT_KEY_NAME \
        -v default_security_groups=[$DEFAULT_SECURITY_GROUPS] \
        --var-file private_key=$PRIVATE_KEY_FILE \
        -v subnet_id=$SUBNET_ID \
        -v postgres_password=$POSTGRES_PASSWORD \
        -v registry_password=$REGISTRY_PASSWORD \
        -o bosh-deployment/external-ip-with-registry-not-recommended.yml \
        -v external_ip=$DIRECTOR_EXTERNAL_IP \
        -o bosh-deployment/jumpbox-user.yml
}

function create_vsphere() {
      # vSphere specific properties

  VCENTER_TEMPLATES=`cat $OPS_CONFIG | jq -r '.iaas_image_location.value'`
  VCENTER_VMS=`cat $OPS_CONFIG | jq -r '.iaas_image.value'`
  VCENTER_DISKS=`cat $OPS_CONFIG | jq -r '.iaas_disk.value'`
  VCENTER_CLUSTER=`cat $OPS_CONFIG | jq -r '.iaas_cluster.value'`
  VCENTER_DC=`cat $OPS_CONFIG | jq -r '.region.value'`
  VCENTER_DS=`cat $OPS_CONFIG | jq -r '.datastore.value'`
  VCENTER_IP=`cat $OPS_CONFIG | jq -r '.iaas_endpoint.value'`
  VCENTER_RESOURCE_POOL=`cat $OPS_CONFIG | jq -r '.iaas_resource_pool.value'`

  bosh2 $ACTION $BD/bosh.yml \
    --state=$DEPLOYMENT_DIR/bosh-init-state.json \
    --vars-store=$DEPLOYMENT_DIR/creds.yml \
    -o $BD/vsphere/cpi.yml \
    -o $BD/misc/dns.yml \
    -o $BD/vsphere/resource-pool.yml \
    -v director_name=$DIRECTOR_NAME \
    -v internal_cidr=$INTERNAL_CIDR \
    -v internal_gw=$INTERNAL_GW \
    -v internal_ip=$INTERNAL_IP \
    -v network_name=$NETWORK_NAME \
    -v vcenter_dc=$VCENTER_DC \
    -v vcenter_ds=$VCENTER_DS \
    -v vcenter_ip=$VCENTER_IP \
    -v vcenter_vms="test-bosh-name" \
    -v vcenter_rp=$VCENTER_RESOURCE_POOL \
    -v internal_dns=$INTERNAL_DNS \
    -v vcenter_user=$IAAS_USER \
    -v vcenter_password=$IAAS_PASSWORD \
    -v vcenter_templates=$VCENTER_TEMPLATES \
    -v vcenter_vms=$VCENTER_VMS \
    -v vcenter_disks=$VCENTER_DISKS \
    -v vcenter_cluster=$VCENTER_CLUSTER \
    -o bosh-deployment/jumpbox-user.yml
}

####################################
#
#   MAIN
#
####################################

# Directory for the bosh-deployment repo.
BD=bosh-deployment
# IAAS to create BOSH on.
IAAS=""
# Cloud configuration yml file
CLOUD_CONFIG_YML=""
# Directory where configuration files are stored.
CONFIG_DIR=""
# Directory where files related to this deployment are stored.
DEPLOYMENT_DIR=""
# Operational configuration file
OPS_CONFIG=""
# IAAS credentials
IAAS_USER=""
IAAS_PW=""
# Default action is to create an environment.
ACTION=create-env

# Parse the command argument list
while getopts "hc:o:p:u:i:d" opt; do
    case "$opt" in
    h|\?)
        usage
        exit 0
        ;;
    c)
        CONFIG_DIR=$OPTARG
        ;;
    d)
        ACTION=delete-env
        ;;
    i)
        IAAS=$OPTARG
        ;;
    o)
        DEPLOYMENT_DIR=$OPTARG
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

CLOUD_CONFIG_YML=$CONFIG_DIR/cloud-config.yml
OPS_CONFIG=$CONFIG_DIR/iaas.json


# Pull in the bosh-deployment submodule. This needed as a base
# when executing the bosh deployment
git submodule init
git submodule update

# IaaS common properties
IAAS_USER=$IAAS_USER
IAAS_PASSWORD=$IAAS_PW
DIRECTOR_NAME=`cat $OPS_CONFIG | jq -r '.director_name.value'`
INTERNAL_CIDR=`cat $OPS_CONFIG | jq -r '.private_subnet_cidr.value'`
INTERNAL_GW=`cat $OPS_CONFIG | jq -r '.internal_gateway.value'`
INTERNAL_IP=`cat $OPS_CONFIG | jq -r '.director_ip.value'`
NETWORK_NAME=`cat $OPS_CONFIG | jq -r '.private_subnet_id.value'`
INTERNAL_DNS=`cat $OPS_CONFIG | jq -r '.iaas_dns.value'`

if [ $IAAS == "vsphere" ]; then
  create_vsphere
elif [ $IAAS == "aws" ]; then
  create_aws
fi

if [ ! -z $DIRECTOR_EXTERNAL_IP ]; then
    echo "using external ip for director"
    DIRECTOR_IP=$DIRECTOR_EXTERNAL_IP
else
    DIRECTOR_IP=$INTERNAL_IP
fi

# If the environment is being created, create an alias and upload the cloud config.
if [ $ACTION == "create-env" ]; then
  bosh2 -e $DIRECTOR_IP --ca-cert <(bosh2 int $DEPLOYMENT_DIR/creds.yml --path /director_ssl/ca) alias-env bootstrap
  export BOSH_CLIENT=admin
  export BOSH_CLIENT_SECRET=`bosh2 int $DEPLOYMENT_DIR/creds.yml --path /admin_password`
  bosh2 -n -e bootstrap ucc $CLOUD_CONFIG_YML
fi
