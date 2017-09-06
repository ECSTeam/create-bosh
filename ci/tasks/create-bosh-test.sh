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

cat <<EOF >> bosh-init-state.json
{
    "director_id": "d5f1803e-c79a-4545-4084-29b7accd21c6",
    "installation_id": "29573a51-ec6e-474d-5fb6-09dd95b7c43f",
    "current_vm_cid": "vm-f0b3d0bb-da35-41b5-827d-67bd66da5967",
    "current_stemcell_id": "c3eb0344-81bf-4432-5cea-028078428218",
    "current_disk_id": "c59518a4-bea7-47ee-6cef-8297d424995a",
    "current_release_ids": [
        "7bd4d49c-5d88-4a4e-7f93-277744c4aa2b",
        "08ab3ee8-a0a4-422a-4fa9-c36c24d9e771"
    ],
    "current_manifest_sha": "ae837c6178c7c725192be0709718709eb7f2ee3fe37053a0fac24d8b92c11ffe9b9ddf10347261f6f8d788369c42952e63b459ec9ed
7baac6995a2fd731aadd5",
    "disks": [
        {
            "id": "c59518a4-bea7-47ee-6cef-8297d424995a",
            "cid": "disk-dadd2de2-43f4-4c48-a781-0ef119e4d091",
            "size": 32768,
            "cloud_properties": {}
        }
    ],
    "stemcells": [
        {
            "id": "c3eb0344-81bf-4432-5cea-028078428218",
            "name": "bosh-vsphere-esxi-ubuntu-trusty-go_agent",
            "version": "3445.7",
            "cid": "sc-238a2735-d08c-486f-ad2a-cf9c1985ef44"
        }
    ],
    "releases": [
        {
            "id": "7bd4d49c-5d88-4a4e-7f93-277744c4aa2b",
            "name": "bosh",
            "version": "263"
        },
        {
            "id": "08ab3ee8-a0a4-422a-4fa9-c36c24d9e771",
            "name": "bosh-vsphere-cpi",
            "version": "44"
        }
    ]
}
EOF

cat <<EOF >> creds.yml
admin_password: xl2w0obbkkd521phuy4y
blobstore_agent_password: zuzwf8pqxdavypg21u48
blobstore_director_password: sqqs0hxunnnu84ky77gb
default_ca:
  ca: |
    -----BEGIN CERTIFICATE-----
    MIIDFDCCAfygAwIBAgIRALMAxSJluWnM77JCWurtTXQwDQYJKoZIhvcNAQELBQAw
    MzEMMAoGA1UEBhMDVVNBMRYwFAYDVQQKEw1DbG91ZCBGb3VuZHJ5MQswCQYDVQQD
    EwJjYTAeFw0xNzA5MDYyMTEyMDFaFw0xODA5MDYyMTEyMDFaMDMxDDAKBgNVBAYT
    A1VTQTEWMBQGA1UEChMNQ2xvdWQgRm91bmRyeTELMAkGA1UEAxMCY2EwggEiMA0G
    CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7JSnTs1TUT9Y9XCNTTKe6b0IJzMeh
    wpTuiHDDqQJTIEbeibh4na3Ba1klSDvnuOYY13FP76dnw/lI00n9sB5UP86s993W
    KErGQC5+V2GKNAN4NFs1bC2/G1yGJ4pjLbNeQkSgKc9/5m54cdmXQswq4eY0vWE5
    bENjnc721WvLXT/VQ5sn6+DpvsgOphV4lQZqXNNsID3mzzSHZVBkbe68mzXUpvIy
    P7BpejWAC4Q5rTquYqSf+8LnZ552qzDFjls8cyuXioVES+RZUz6t+8gjb4DNDstU
    hObfgawW/RqLgby4IyjKtrd4JR9LBvciPQkJdP5HRTvbVnRcx4R0uiX/AgMBAAGj
    IzAhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEB
    CwUAA4IBAQBfCGOAFzO+EbGaeIHu7llI+PB6R7ZusnDrFzY2TGWsrhkzWMqRZ0Fn
    jN2lLdQw3TUSCTL9h72G5HEi5V6Om6KyEdPurr91GiQlYyElvY1qQqP8F42UGeFm
    rSkLyYzArVEUm/uOSBDXwEJRExW7b8kixqu11BN707PaWcOcKzcuSjZ+XCInsQvh
    bWd6r4mgZYFFjvR8sOQ5v4c57Lpz4mZMx0kfAFVmS7CWHp6OWfnsJyKcmE4VUJhR
    TGPEwhc8SSBFQjpGObiMIcyZqm7BpFaNiTLlB83OwJY2VHVQfunVAU37lYoJUXan
    K1CEiTJhuhIT9SDJj5sZcChhrMP9ed0w
    -----END CERTIFICATE-----
  certificate: |
    -----BEGIN CERTIFICATE-----
    MIIDFDCCAfygAwIBAgIRALMAxSJluWnM77JCWurtTXQwDQYJKoZIhvcNAQELBQAw
    MzEMMAoGA1UEBhMDVVNBMRYwFAYDVQQKEw1DbG91ZCBGb3VuZHJ5MQswCQYDVQQD
    EwJjYTAeFw0xNzA5MDYyMTEyMDFaFw0xODA5MDYyMTEyMDFaMDMxDDAKBgNVBAYT
    A1VTQTEWMBQGA1UEChMNQ2xvdWQgRm91bmRyeTELMAkGA1UEAxMCY2EwggEiMA0G
    CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7JSnTs1TUT9Y9XCNTTKe6b0IJzMeh
    wpTuiHDDqQJTIEbeibh4na3Ba1klSDvnuOYY13FP76dnw/lI00n9sB5UP86s993W
    KErGQC5+V2GKNAN4NFs1bC2/G1yGJ4pjLbNeQkSgKc9/5m54cdmXQswq4eY0vWE5
    bENjnc721WvLXT/VQ5sn6+DpvsgOphV4lQZqXNNsID3mzzSHZVBkbe68mzXUpvIy
    P7BpejWAC4Q5rTquYqSf+8LnZ552qzDFjls8cyuXioVES+RZUz6t+8gjb4DNDstU
    hObfgawW/RqLgby4IyjKtrd4JR9LBvciPQkJdP5HRTvbVnRcx4R0uiX/AgMBAAGj
    IzAhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEB
    CwUAA4IBAQBfCGOAFzO+EbGaeIHu7llI+PB6R7ZusnDrFzY2TGWsrhkzWMqRZ0Fn
    jN2lLdQw3TUSCTL9h72G5HEi5V6Om6KyEdPurr91GiQlYyElvY1qQqP8F42UGeFm
    rSkLyYzArVEUm/uOSBDXwEJRExW7b8kixqu11BN707PaWcOcKzcuSjZ+XCInsQvh
    bWd6r4mgZYFFjvR8sOQ5v4c57Lpz4mZMx0kfAFVmS7CWHp6OWfnsJyKcmE4VUJhR
    TGPEwhc8SSBFQjpGObiMIcyZqm7BpFaNiTLlB83OwJY2VHVQfunVAU37lYoJUXan
    K1CEiTJhuhIT9SDJj5sZcChhrMP9ed0w
    -----END CERTIFICATE-----
  private_key: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAuyUp07NU1E/WPVwjU0ynum9CCczHocKU7ohww6kCUyBG3om4
    eJ2twWtZJUg757jmGNdxT++nZ8P5SNNJ/bAeVD/OrPfd1ihKxkAufldhijQDeDRb
    NWwtvxtchieKYy2zXkJEoCnPf+ZueHHZl0LMKuHmNL1hOWxDY53O9tVry10/1UOb
    J+vg6b7IDqYVeJUGalzTbCA95s80h2VQZG3uvJs11KbyMj+waXo1gAuEOa06rmKk
    n/vC52eedqswxY5bPHMrl4qFREvkWVM+rfvII2+AzQ7LVITm34GsFv0ai4G8uCMo
    yra3eCUfSwb3Ij0JCXT+R0U721Z0XMeEdLol/wIDAQABAoIBAAtUtLOcqAYyz0Xn
    zju86GrhUZ5GR9ADeAD5QdqW4Q0nZyMSM5kZ8utDFKKtPPNKvqPCZ5nvaLNfqjg+
    krxJbYysUFcoqsXMqrpWKHp9z+oOPCeLA/q4Eg0AGxoESty2Z6XNXVpVLbsQuJ+S
    RRpjcPkntEh9LuXLKElfxKgtQ9mMMUzIMcP2U9KbB+d23lNrA1hyBd9NgO7GyafA
    QKfo69NLWfJxZO/fwjiYw6eFTx2ep30WtB77rQKEPemXEganIzFx4aQvprJQZONG
    rPmfl1bZtujO76naVPrEolA6RHsXp1ZejO0KqC42dFWBMKANaLra24ytabHDygJp
    xeV5IAECgYEA1FtG4KE83nBOSUEfjwvcDWqc5JZCqpuKhJuOq1Fr03A5GLzXN1pb
    E1k/Rt4CyJJSKGIGj5UUp7C+bEZxcxIqK505o2rlj7uIFcftu8EK6jKVNLUF1Yfc
    u1MNMXHND1f7amOKhSnCJmRj5q2NTbbS6RX0gEexSV8+UbyG9zS9Qh8CgYEA4Ztw
    b2tSou4ol2qCBcLUaEKACp7wJAzVsQw7Q4PwUThOrcBevNN2BtjP0bYZ2m65tatx
    rntulzN7v79jUG2jjQD2PG2X3rKhRxr5G64x1kyn3HJ/H44TmavVsxsV7vwIOrdQ
    KyOQGcuVs7bs4RTU6b2X0ihKPuzF08YzoOlXYCECgYA7qa1/PS3p3SnRoQ9p1E4u
    Is8T1jfC0VKYsU/jSEwAKt6P2bap4aQHCqMhmQy1J48Xs3reamdUOe82YpBLYUYh
    3Nmt1UHMIUc5v2NGxhT3+eA738RU2wgkRVBGnQ+dCP4lRPRNN49J1BjRXd9+fyhA
    vp9kT0A7Ohw7QLm2yMWHxwKBgHlfoLuwp4KUUi4z1MO4r4Fv1WbhXxxl80kO5YtL
    Hizz+BAuIEnCEgtY9WVDbOFBFJQSKlTOfw7FWdws4QdSFN01GUQlScE7pNyWPFKS
    AqniD6TfzFhznUPdWFjFR6WM3fiIyo6K0WmvR1iqHwJwrKMbpuQfXOJBi6SFSx1U
    q/dBAoGAb/ifoOXrQWfUGftGSpIyw6+LGMvcro5xFkwl6FnmFjzRM+M8KKNC++Fl
    PFrk/bzkLfTn881RGoF91RtWYqZqrF5yJyAougevRGRG0a77aMRO6Hy10Pw5llu2
    1Z2xxdvAFTXdzfy12T9v+JENFgaXQIzv3FS8umfpIJaTJSdq5JE=
    -----END RSA PRIVATE KEY-----
director_ssl:
  certificate: |
    -----BEGIN CERTIFICATE-----
    MIIDQTCCAimgAwIBAgIRAJ2gjo3h7ZMr3i+KrcjWZr4wDQYJKoZIhvcNAQELBQAw
    MzEMMAoGA1UEBhMDVVNBMRYwFAYDVQQKEw1DbG91ZCBGb3VuZHJ5MQswCQYDVQQD
    EwJjYTAeFw0xNzA5MDYyMTEyMDFaFw0xODA5MDYyMTEyMDFaMD0xDDAKBgNVBAYT
    A1VTQTEWMBQGA1UEChMNQ2xvdWQgRm91bmRyeTEVMBMGA1UEAxMMMTcyLjI4Ljk4
    LjUwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyGp8Z5eTlyxYSv6H
    /HQGas8MZimc9eclYqoeqPf1GBaHRzyHmLpYU6dCIKPxSfcbDCVbFDsfZ1k4h4e5
    72KS+RHg1WY96f/s3cvTSsYoslTeOJPMJSvy9bxQ+rquTrLmf0s1l7IjGwx7F8fZ
    eaA91ekHRPrAdnrdrfy97t5B2q4JAghpKslyXOxenzHT5HXslMa1Lol4ep1nsFjN
    Sp92xwiCF1iJq8SZKtJiLpH0+f4t9692q5xC5ioOm0esxCgMBeXbCrVVvyfSfX6g
    +PXIv/ijbaTxihpxJscIVhNznl1fm2TBOQelJsBUg0Y1Ok8UbOb5Q7FzLrfzcLKi
    GP9CdwIDAQABo0YwRDAOBgNVHQ8BAf8EBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUH
    AwEwDAYDVR0TAQH/BAIwADAPBgNVHREECDAGhwSsHGIyMA0GCSqGSIb3DQEBCwUA
    A4IBAQCkqYZnrZ+q/dNV2+8GySfR98GrvXb8fTsa/SAhyp62CoYBqAPk7e+hZhHu
    SVQ1EHfdEt3TfC3rKgZYChNy/Z7ju6o85gwvZvmbL3hhlrLgnso3w6rPn+G6pdpS
    T8yfTT+i7Da8Ak9f4lHS1JLjJBCMd6fGKbFcM9mGXiwB/eqCqTl6Li8rZcASHHQ7
    Dj7eAUmRx+kS3UK4sZ+YBc8nD2lK5BpsBPCRKM1E5nlPfmOio94XI2Z4T8fjxrVh
    LKebdKm9TsX8Or1RKrBvxx721qQ3ZlDLr6Wc8UnT67UqnuWdtIxpY6F3wQ8GrfWA
    8myqp8Or6QBQoI+EPcA7sQn+1eMo
    -----END CERTIFICATE-----
  private_key: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAyGp8Z5eTlyxYSv6H/HQGas8MZimc9eclYqoeqPf1GBaHRzyH
    mLpYU6dCIKPxSfcbDCVbFDsfZ1k4h4e572KS+RHg1WY96f/s3cvTSsYoslTeOJPM
    JSvy9bxQ+rquTrLmf0s1l7IjGwx7F8fZeaA91ekHRPrAdnrdrfy97t5B2q4JAghp
    KslyXOxenzHT5HXslMa1Lol4ep1nsFjNSp92xwiCF1iJq8SZKtJiLpH0+f4t9692
    q5xC5ioOm0esxCgMBeXbCrVVvyfSfX6g+PXIv/ijbaTxihpxJscIVhNznl1fm2TB
    OQelJsBUg0Y1Ok8UbOb5Q7FzLrfzcLKiGP9CdwIDAQABAoIBAF6BmFhhKb/HsXrr
    u8RYEg6bxAUI6nMqpH56KisTggfx16jH6kki1jPcU1qA9G8kjySTGPfZSV26vOVs
    I0m2+gdpXtRCej+150RPsTs5ZkdxrbiQOVvt9YvbWXRiQ3/o7LhqBsOZxOQkZoc4
    Pl0UKxSL5lmoxMkZ9x7sZ8QUGom7YXxVj3FR5MWCWGkjXzU1k9qmH3cbXSGdn8zt
    7N0vJHEyc+aPWobE2HWhojUoT48zOg38tupxr2Rrbihvyea5kl/dagRey/qNgvcN
    iUIhwtLxMt5bZL/G60TJ/b8CgPNCoE1ZrIsxV5LtA1jEOzkX2gAn5vPbqL0EOr8z
    vYiMD8ECgYEA1AA8WzGn2ISOqS96/DNQjxXnWolaYNzwWAgSWaxEYUolfYN8ZtPC
    d2wQMevv4QIl/pYygAic3XzMSvpQ0n5feaydxs4sCMvq4ewF1Euqm4Gn3NUUju9Z
    HsPtCfupe0J2PtMli2FneNDtYWdS9twkllPGSE8z/WguJC2KHR2Bz3sCgYEA8gK7
    lqFyAIB/69CisZUCCN4E+k/fEc8oHMHwwAB31N89gAebLsmzAxumwRHWdVKLbzBC
    igcPWhhce9OcgfKFGZfogKOUO3GaIrJWZyeJS/QgWcjjmB/LXp2F4FMfSNQ4FIXD
    EkgJYvjxLtYr7/4uk17k22cddqGmtIb2+gulijUCgYBakz82NyDfAMNyxTZmSgZB
    G7qck9JpT/vfoJM2fMM6TdN2rJaZ2B9dpm3E5mi2WZSiEMnCqetbNdaSsh+Vzyg7
    c+R06+EkYPsZSx2ydiGODvcJAoCmENyiqFK90Se34c1jShLgWd07YQgKdXqcvbFk
    CKbOfghYXApaqpo3lkO/wQKBgFLm4L++2kCVxDxRognXE3VaKLZeefmtzv3a6c+7
    2VDQkE61TFGAwpPD+yGULLTP6/fQvlpuBLJGOhgo6yoQm8uioADBCFw8lCJimPqJ
    Lp0YKaTYDi7kZVQp/dxUXRkjqXpOP/6ZMq32vRfgQfjaR7YwAZGvBwbGZUbeHOiW
    6MQpAoGAGbQ31QDK6er8B62vDk0YNE1jOGJA1yRcaL3Pn2OgP1EMpdQgUTI5riKJ
    Jcoo0ou/FkL/iQQeiw+GyoC0FynzR7LqCI8qfUPDlC7U9HczP3bfkYERxMkxstW5
    1uESJctTol1TO9FCkGKoqsfHu6Jbxd3VqF3W7k/Z7tR0ff183Os=
    -----END RSA PRIVATE KEY-----
  ca: |
    -----BEGIN CERTIFICATE-----
    MIIDFDCCAfygAwIBAgIRALMAxSJluWnM77JCWurtTXQwDQYJKoZIhvcNAQELBQAw
    MzEMMAoGA1UEBhMDVVNBMRYwFAYDVQQKEw1DbG91ZCBGb3VuZHJ5MQswCQYDVQQD
    EwJjYTAeFw0xNzA5MDYyMTEyMDFaFw0xODA5MDYyMTEyMDFaMDMxDDAKBgNVBAYT
    A1VTQTEWMBQGA1UEChMNQ2xvdWQgRm91bmRyeTELMAkGA1UEAxMCY2EwggEiMA0G
    CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7JSnTs1TUT9Y9XCNTTKe6b0IJzMeh
    wpTuiHDDqQJTIEbeibh4na3Ba1klSDvnuOYY13FP76dnw/lI00n9sB5UP86s993W
    KErGQC5+V2GKNAN4NFs1bC2/G1yGJ4pjLbNeQkSgKc9/5m54cdmXQswq4eY0vWE5
    bENjnc721WvLXT/VQ5sn6+DpvsgOphV4lQZqXNNsID3mzzSHZVBkbe68mzXUpvIy
    P7BpejWAC4Q5rTquYqSf+8LnZ552qzDFjls8cyuXioVES+RZUz6t+8gjb4DNDstU
    hObfgawW/RqLgby4IyjKtrd4JR9LBvciPQkJdP5HRTvbVnRcx4R0uiX/AgMBAAGj
    IzAhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEB
    CwUAA4IBAQBfCGOAFzO+EbGaeIHu7llI+PB6R7ZusnDrFzY2TGWsrhkzWMqRZ0Fn
    jN2lLdQw3TUSCTL9h72G5HEi5V6Om6KyEdPurr91GiQlYyElvY1qQqP8F42UGeFm
    rSkLyYzArVEUm/uOSBDXwEJRExW7b8kixqu11BN707PaWcOcKzcuSjZ+XCInsQvh
    bWd6r4mgZYFFjvR8sOQ5v4c57Lpz4mZMx0kfAFVmS7CWHp6OWfnsJyKcmE4VUJhR
    TGPEwhc8SSBFQjpGObiMIcyZqm7BpFaNiTLlB83OwJY2VHVQfunVAU37lYoJUXan
    K1CEiTJhuhIT9SDJj5sZcChhrMP9ed0w
    -----END CERTIFICATE-----
hm_password: w93yxp7soiisheyf0e2o
mbus_bootstrap_password: sws2u7t0mrpyua0xnzw4
mbus_bootstrap_ssl:
  ca: |
    -----BEGIN CERTIFICATE-----
    MIIDFDCCAfygAwIBAgIRALMAxSJluWnM77JCWurtTXQwDQYJKoZIhvcNAQELBQAw
    MzEMMAoGA1UEBhMDVVNBMRYwFAYDVQQKEw1DbG91ZCBGb3VuZHJ5MQswCQYDVQQD
    EwJjYTAeFw0xNzA5MDYyMTEyMDFaFw0xODA5MDYyMTEyMDFaMDMxDDAKBgNVBAYT
    A1VTQTEWMBQGA1UEChMNQ2xvdWQgRm91bmRyeTELMAkGA1UEAxMCY2EwggEiMA0G
    CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7JSnTs1TUT9Y9XCNTTKe6b0IJzMeh
    wpTuiHDDqQJTIEbeibh4na3Ba1klSDvnuOYY13FP76dnw/lI00n9sB5UP86s993W
    KErGQC5+V2GKNAN4NFs1bC2/G1yGJ4pjLbNeQkSgKc9/5m54cdmXQswq4eY0vWE5
    bENjnc721WvLXT/VQ5sn6+DpvsgOphV4lQZqXNNsID3mzzSHZVBkbe68mzXUpvIy
    P7BpejWAC4Q5rTquYqSf+8LnZ552qzDFjls8cyuXioVES+RZUz6t+8gjb4DNDstU
    hObfgawW/RqLgby4IyjKtrd4JR9LBvciPQkJdP5HRTvbVnRcx4R0uiX/AgMBAAGj
    IzAhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEB
    CwUAA4IBAQBfCGOAFzO+EbGaeIHu7llI+PB6R7ZusnDrFzY2TGWsrhkzWMqRZ0Fn
    jN2lLdQw3TUSCTL9h72G5HEi5V6Om6KyEdPurr91GiQlYyElvY1qQqP8F42UGeFm
    rSkLyYzArVEUm/uOSBDXwEJRExW7b8kixqu11BN707PaWcOcKzcuSjZ+XCInsQvh
    bWd6r4mgZYFFjvR8sOQ5v4c57Lpz4mZMx0kfAFVmS7CWHp6OWfnsJyKcmE4VUJhR
    TGPEwhc8SSBFQjpGObiMIcyZqm7BpFaNiTLlB83OwJY2VHVQfunVAU37lYoJUXan
    K1CEiTJhuhIT9SDJj5sZcChhrMP9ed0w
    -----END CERTIFICATE-----
  certificate: |
    -----BEGIN CERTIFICATE-----
    MIIDQDCCAiigAwIBAgIQeR95Cvs3ofnAwuF70nv7XTANBgkqhkiG9w0BAQsFADAz
    MQwwCgYDVQQGEwNVU0ExFjAUBgNVBAoTDUNsb3VkIEZvdW5kcnkxCzAJBgNVBAMT
    AmNhMB4XDTE3MDkwNjIxMTIwMVoXDTE4MDkwNjIxMTIwMVowPTEMMAoGA1UEBhMD
    VVNBMRYwFAYDVQQKEw1DbG91ZCBGb3VuZHJ5MRUwEwYDVQQDEwwxNzIuMjguOTgu
    NTAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDZCsIv8Fo37WN6OgzL
    25Me73klfQrLnlaOUxYXxW3YYc2GVVRusdj/1wZO3HhrPk01MZKXw0gfTv6Z6uoC
    FK/FSQq7sdkjSwclnaxT6XxCJNIJKh7Bwn2Asvl02mzfBr7peIOmoKSN4cJX1moR
    lpzZHwSG1b+8DYBiElGigNWQNU5dwid9HItuEW8JHW4el6nrmbT3m9rDxAhbt4u7
    aC5WZaH5UT5wMEgQEZ0GigjXZJyswmb7ns1UqaXhYZmGeb/7ATrt4s46nLe6SFYy
    941Z9wmCWBOHMMJflhVbHJD79KF1+ipMfYnGfXE/gZBc332ZfjrCF+32YQoUse2I
    SbA9AgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIFoDATBgNVHSUEDDAKBggrBgEFBQcD
    ATAMBgNVHRMBAf8EAjAAMA8GA1UdEQQIMAaHBKwcYjIwDQYJKoZIhvcNAQELBQAD
    ggEBACjKmcjxEnZz05kKLyR/sNXMY2kgCcJyI7BzDUOKbbIP6SKooOLWg/YyDiB9
    By+GbWgnWIzgKAny6Dj/6p5K8oiH3bBvW40p5xdz3gEjEI4P6jtS/VTyOOLR+ayU
    ipkRXmny+RoVzUXxTUEd5nOnYadUssi08zVZbTnBfG4EGQMKsxFD/BamXGoERge5
    bO54MAb4vawtu1ylqrHkBhjCDaIHg7lR0Z9XYm2Fd5pb2O4gNHeyGaUPd5pclHmW
    nlHLGJKVZQ9K1aOLuyhAgAVlxLatoqRnhyIb9da+y2DAFWTSl+7jEffwIYtBx5Mh
    nBgmurKytkRSXrv4c6PFAn4Hiyg=
    -----END CERTIFICATE-----
  private_key: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEA2QrCL/BaN+1jejoMy9uTHu95JX0Ky55WjlMWF8Vt2GHNhlVU
    brHY/9cGTtx4az5NNTGSl8NIH07+merqAhSvxUkKu7HZI0sHJZ2sU+l8QiTSCSoe
    wcJ9gLL5dNps3wa+6XiDpqCkjeHCV9ZqEZac2R8EhtW/vA2AYhJRooDVkDVOXcIn
    fRyLbhFvCR1uHpep65m095vaw8QIW7eLu2guVmWh+VE+cDBIEBGdBooI12ScrMJm
    +57NVKml4WGZhnm/+wE67eLOOpy3ukhWMveNWfcJglgThzDCX5YVWxyQ+/Shdfoq
    TH2Jxn1xP4GQXN99mX46whft9mEKFLHtiEmwPQIDAQABAoIBAQC6hjZwgHzoR4kQ
    R8crgx6inWddwmJ+ryrv0ZPRBgjqxtKcOcUABLPa2u4+49ZRRA+SQXIcHuVikr7X
    hD1rYF/WinlA6Q0U+avAtgqdarExHveqjJo2JnE5I5aix/x8hw2XE80AbFo+3N/q
    IQiy6N8O8UswnY3TjT7iCaBCqbnf3Xm0NnACzT9Z/zO7lUU0023mvKBajg+ALPfN
    JM0qnSB7PJWSVXfpCumtTNcHKXJHHdE5D7fBz7HMB3GyQJkBAdoQgLo8wWXQoTQf
    Rr1dSh8YHkmlTRi6ldBpVw92uw5qpR8jnCfPplcwPGEnYRq+/NdDyeeqWQCC+Ixs
    5SV0yZ6BAoGBAP03y/2ot73w4PNgTh3zRD8elYeSsjGGV06UH54vcoJ/glW/9Azd
    MsPqZdxgk5CAJRo/oW/szBtZXnqjTDZbNiyUloyWwVI83kr19qYBYCJmEnjnKRzm
    DwTpAhwDaDo/9oD7raAjfEwPFhS4B1O0qW9wy4FLhookTTYHoEZBSsfxAoGBANtt
    NoO/hBwnPpVyImy/5kW14zEUYJohXCUC/2nq7XwYEAK7SoLqF7GeByXV6diGl2eh
    4I32ufPTc/pRf+xgAO/Zhvex1EjUSUC9LddWcB4QPXZ4/YmpeXgD1HfSJKgo+1ib
    2LEfkXD1GoDY4exw+odsrmsCn6GHE0bLgnT4ZxkNAoGAaSTbGogNS9ySu9xYc41I
    4GDFvFbIkVH0PNe6zUdsaA2kRBEBuLm806coBrs/avga7+xOD5inJBAW8BuQkN2N
    ADPu04/h1FEcCMpbUZEupvn1X6i05KAOyn4qdxFfHRjkNajL7rvtZ/O3uoCz4ikZ
    VgHjLtv6kLAEM5Q1FBcWgzECgYBbNpQBwlv9hAbNAuvyfvcPJWPy5ACgMZvnOs7H
    zcO44RvOtuJrdzowOHvKK5kQzComBzGcceKsy8qbVMOzk9jv22Hylzaiq7RjuABV
    UnY62Q9jrzndvthinlz1DiL00Exjci1qu6+u4ASLaRzJN9G8992tWCLZd5f4xuJN
    E3FwBQKBgQDCY2tYhVtzLzGIv8Zcb6Ga3DYd8dXoLSiUUo4zXkKrQ8bpNJ53zs5l
    w8kR0gxr3Et6aqvqKlcvThZOxn+i2RNXKnWyaZS6aYgaSqCLyakJvtLplxQ2ELI5
    zsnlNILR9F7nf48q9FHuehmV877vetQlw9cKtX0R2B/PWeFdc0k2tA==
    -----END RSA PRIVATE KEY-----
nats_password: xxv1xzyfe979i9n1hqw3
postgres_password: gya2973ultmow6uhq5kk
EOF

# create-bosh/create-bosh.sh -i vsphere -o iaas.json -u lab09admin@lab.ecsteam.local \
#    -p Ecsl@b99

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh2 int ./creds.yml --path /admin_password`

bosh2 -e bootstrap l

create-bosh/create-bosh.sh -d -i vsphere -o iaas.json -u lab09admin@lab.ecsteam.local \
   -p Ecsl@b99

# verify bosh is deleted with some command
