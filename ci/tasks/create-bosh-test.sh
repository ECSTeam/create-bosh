#!/bin/bash -e

set -x

EXPECTED_HELP='USAGE:
   create-bosh.sh -i <IAAS> -o <operational config file> -u <IAAS user> -p <IAAS password> [-d]

-d - delete the current deployment

Supported IaaSes - vsphere, gcp, azure, aws'

ACTUAL_HELP=`create-bosh/create-bosh.sh -h`

# Fail test if help message is not as expected.
if [[ "$ACTUAL_HELP" != "$EXPECTED_HELP" ]]; then
  echo "Unexpected help message : $ACTUAL_HELP"
  exit 1
fi

cat <<EOF >> iaas.json
{
    "jumpbox_az": {
        "sensitive": false,
        "type": "string",
        "value": "us-east-1a"
    },
    "jumpbox_public_ip": {
        "sensitive": false,
        "type": "string",
        "value": "54.89.13.216"
    },
    "jumpbox_security_group": {
        "sensitive": false,
        "type": "string",
        "value": "sg-a8d582d8"
    },
    "prefix": {
        "sensitive": false,
        "type": "string",
        "value": "mpm"
    },
    "private_subnet_cidr": {
        "sensitive": false,
        "type": "string",
        "value": "172.28.98.0/24"
    },
    "private_subnet_id": {
        "sensitive": false,
        "type": "string",
        "value": "Lab09-NetH"
    },
    "public_subnet_cidr": {
        "sensitive": false,
        "type": "string",
        "value": "172.28.98.0/24"
    },
    "public_subnet_id": {
        "sensitive": false,
        "type": "string",
        "value": "subnet-0ed18054"
    },
    "region": {
        "sensitive": false,
        "type": "string",
        "value": "Lab09-Datacenter01"
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
        "value": "172.28.98.1"
    },
    "director_ip": {
        "sensitive": false,
        "type": "string",
        "value": "172.28.98.50"
    },
    "datastore": {
        "sensitive": false,
        "type": "string",
        "value": "nfs-lab09-vol1"
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
        "value": "Lab09-Cluster01"
    }
}
EOF

create-bosh/create-bosh.sh -i vsphere -o iaas.json -u lab09admin@lab.ecsteam.local \
   -p Ecsl@b99

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh2 int ./creds.yml --path /admin_password`

bosh2 -e bootstrap l

create-bosh/create-bosh.sh -d -i vsphere -o iaas.json -u lab09admin@lab.ecsteam.local \
   -p Ecsl@b99

# verify bosh is deleted with some command
