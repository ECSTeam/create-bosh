# create-bosh

A BOSH deployment is a standard part of an Enterprise infrastructure. At the
very least, it is used to manage a Concourse environment. `create-bosh.sh` creates a BOSH environment based on given configuration.

# Installation

Place create-bosh.sh on your PATH.

# Usage

create-bosh.sh expects that a cloud-config.yml and iaas.json exist in the configuration 
directory. The iaas.json contains the IaaS specific configuration for BOSH. The
iaas.<IaaS>.stub.json can be used as an example. The cloud-config.yml will be loaded into the newly created BOSH director.

Arguments:
    -c <config directory> - The directory where configuration files
       are stored. 
    -o <deployment directory> - The directory where gerenated files are stored.
        The thought is, this directory would be persisted in an
        object store, github or something form of persistence.
    -i <IaaS> - the IaaS BOSH will be deployed to.
    -u <IaaS user> - IaaS user with permissions to perform a deployment.
    -p <IaaS password> - password for the IaaS user.
    -d - use this option to delete a deployment.