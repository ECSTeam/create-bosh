#!/bin/bash -e
##############################################################
#
#  Test case for the create-bosh.sh script. This script
#  tests the help message is as expected and if a bosh
#  instance is created as expected.
#
##############################################################
set -x

EXPECTED_HELP='USAGE:
   create-bosh.sh -o <deployment directory> -i <IAAS> -u <IAAS user> -p <IAAS password> [-d]

-d - delete the current deployment

Supported IaaSes - vsphere, gcp, azure, aws'

ACTUAL_HELP=`create-bosh/create-bosh.sh -h`

# Fail test if help message is not as expected.
if [[ "$ACTUAL_HELP" != "$EXPECTED_HELP" ]]; then
  echo "Unexpected help message : $ACTUAL_HELP"
  exit 1
fi

# Create the directory where files specific to this deployment are housed.
DEPLOYMENT_DIR=`pwd`/test-deployment

mkdir $DEPLOYMENT_DIR

cat <<EOF >> $DEPLOYMENT_DIR/iaas.json
{
    "private_subnet_cidr": {
        "sensitive": false,
        "type": "string",
        "value": "172.28.14.0/24"
    },
    "private_subnet_id": {
        "sensitive": false,
        "type": "string",
        "value": "Lab01-NetD"
    },
    "public_subnet_cidr": {
        "sensitive": false,
        "type": "string",
        "value": "172.28.14.0/24"
    },
    "public_subnet_id": {
        "sensitive": false,
        "type": "string",
        "value": "subnet-0ed18054"
    },
    "region": {
        "sensitive": false,
        "type": "string",
        "value": "Lab01-Datacenter01"
    },
    "vpc_id": {
        "sensitive": false,
        "type": "string",
        "value": "vpc-de8cbda7"
    },

    "director_name": {
        "sensitive": false,
        "type": "string",
        "value": "bootstrap-bosh"
    },
    "internal_gateway": {
        "sensitive": false,
        "type": "string",
        "value": "172.28.14.1"
    },
    "director_ip": {
        "sensitive": false,
        "type": "string",
        "value": "172.28.14.53"
    },
    "datastore": {
        "sensitive": false,
        "type": "string",
        "value": "nfs-Lab01-vol1"
    },
    "iaas_endpoint": {
        "sensitive": false,
        "type": "string",
        "value": "172.29.0.11"
    },
    "iaas_dns": {
        "sensitive": false,
        "type": "string",
        "value": "[172.29.0.5]"
    },
    "iaas_image_location": {
        "sensitive": false,
        "type": "string",
        "value": "bosh-templates"
    },
    "iaas_image": {
        "sensitive": false,
        "type": "string",
        "value": "bosh-vms"
    },
    "iaas_disk": {
        "sensitive": false,
        "type": "string",
        "value": "bosh-disks"
    },
    "iaas_cluster": {
        "sensitive": false,
        "type": "string",
        "value": "Lab01-Cluster01"
    }
}
EOF

cat <<EOF >> $DEPLOYMENT_DIR/cloud-config.yml
azs:
- cloud_properties:
    datacenters:
    - clusters:
      - Lab01-Cluster01: {}
  name: z1
- cloud_properties:
    datacenters:
    - clusters:
      - Lab01-Cluster01: {}
  name: z2
- cloud_properties:
    datacenters:
    - clusters:
      - Lab01-Cluster01: {}
  name: z3
compilation:
  az: z1
  network: default
  reuse_compilation_vms: true
  vm_type: default
  workers: 5
disk_types:
- disk_size: 3000
  name: default
- disk_size: 50000
  name: large
networks:
- name: default
  subnets:
  - azs:
    - z1
    - z2
    - z3
    cloud_properties:
      name: Lab01-NetD
    dns:
    - 172.29.0.5
    gateway: 172.28.14.1
    range: 172.28.14.0/24
    reserved:
    - 172.28.14.1-172.28.14.50
    static: [172.28.14.51-172.28.14.60]
  type: manual
vm_types:
- cloud_properties:
    cpu: 2
    disk: 3240
    ram: 1024
  name: default
- cloud_properties:
    cpu: 2
    disk: 30240
    ram: 4096
  name: large
- cloud_properties:
    cpu: 2
    disk: 120960
    ram: 4096
  name: large-disk
EOF

cd create-bosh

alias bosh=bosh2

./create-bosh.sh -i vsphere -o $DEPLOYMENT_DIR -u lab01admin@lab.ecsteam.local \
   -p Ecsl@b99

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh2 int $DEPLOYMENT_DIR/creds.yml --path /admin_password`

bosh2 -e bootstrap l

./create-bosh.sh -d -i vsphere -o $DEPLOYMENT_DIR -u lab01admin@lab.ecsteam.local \
   -p Ecsl@b99

# turn off failing on error because the ping is expected to fail.
set +e
ping -t1 -c1 172.28.14.50 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
  echo "FAILED: BOSH VM still exists."
  exit 1
fi

echo "SUCCESS: BOSH VM deleted."
