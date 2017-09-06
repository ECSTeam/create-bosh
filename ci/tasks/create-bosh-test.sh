#!/bin/bash -e

set -x

EXPECTED_HELP="USAGE:
   create-bosh.sh -i <IAAS> \
     -o <operational config file> -u <IAAS user> -p <IAAS password>

Support IAASes - vsphere, gcp, azure, aws"

ACTUAL_HELP=`create-bosh/create-bosh.sh -h`

# Fail test if help message is not as expected.
if [[ $ACTUAL_HELP != $EXPECTED_HELP ]]; then
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

# create-bosh/create-bosh.sh -i vsphere -o iaas.json -u lab09admin@lab.ecsteam.local \
#    -p Ecsl@b99

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=e0c1wrd7yeuyrl6th5gk
cat <<EOF >> cert
-----BEGIN CERTIFICATE-----
MIIDFDCCAfygAwIBAgIRAIpSm0zicl69zY+/tkZQVk4wDQYJKoZIhvcNAQELBQAw
MzEMMAoGA1UEBhMDVVNBMRYwFAYDVQQKEw1DbG91ZCBGb3VuZHJ5MQswCQYDVQQD
EwJjYTAeFw0xNzA5MDYxOTU5NTZaFw0xODA5MDYxOTU5NTZaMDMxDDAKBgNVBAYT
A1VTQTEWMBQGA1UEChMNQ2xvdWQgRm91bmRyeTELMAkGA1UEAxMCY2EwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvTVy2EzxzJfY0ga+jW8zvrfNlH5xQ
ahJmTmFHnCzTtrDpzcur5XZi2wSL24AYKXDx8tBHHeDNEv2mgNCjob7WOhDGXJzR
GNFG/5VG4zVnwUFrW3+xHWRS/INzK1za+hEKsSTQ4U0l1lHEXkORk+T0IHymqiwS
qTQZmBLsa5R0qOcyDY4mIA14WdwXhWCTzwXd80HTunGOFt//cISYuIP6lT9SPXJ6
G5I6IjCnwCY/CPsA9tqM/uhO3jrFW7zh5RilMwOErSryholXjDhCqAFU3WY9Zun6
+Omb4OkXjjc+29t+Pv819I92jTovuYW9fiStVLE9D6BcvGwNPqhZzVC9AgMBAAGj
IzAhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEB
CwUAA4IBAQArCnj0ZMzNagOYQfLtvR7asn+iVNpZrsNQmVnmV1bfo9kIAODrLFwT
6UxdE+PUH+lYld2zGO0+Kwo+wPYAqcHT55WAz5hvPV221+JmMSSII6wGHRtpyb58
vrUVgc8BV/nurOJo0qeR67nN5pHJOGcKexgA1kNU6flTUk/Ooj5jh29lEmsvrO/j
HwYbITrBYXQHaH39qcLoQ5jLMeSJKt5r4FnPk+XuhsCTwVELoWTskTv0Ms91uZ5t
dUz0dvTtxl8yF6Bt3Yqdc6wGq3NoYCI3HMcusSbOrrc3BJpR+58DicCFqe67iy0h
OueQPy/2KBGg+4ygpdtInmD0ebfoKdgk
-----END CERTIFICATE-----
EOF

bosh2 -e 172.28.98.50 --ca-cert cert alias-env bootstrap

bosh2 -e bootstrap l

create-bosh/create-bosh.sh -d -i vsphere -o iaas.json -u lab09admin@lab.ecsteam.local \
   -p Ecsl@b99

# verify bosh is deleted with some command
