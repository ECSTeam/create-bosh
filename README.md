# create-bosh

A BOSH deployment is a standard part of an Enterprise infrastructure. At the
very least, it is used to manage a Concourse environment. `create-bosh.sh` creates a BOSH environment based on given configuration.

# Installation
Place create-bosh.sh on your PATH.
### create infrastructure for aws
1. Make copy of terraform/aws/env.sh.sample file and modify the parameters as necessary.  
2. Source the env.sh
3. Run `terraform apply`. terraform.tfstate file is created.
4. Make copy of iaas..aws.stub.json to iaas.json and make necessary changes
5. Get the subnet id(`terraform state show aws_subnet.BoshVpcPublicSubnet_az1 | grep ^id`) and bosh director public ip(`terraform state show aws_eip.BoshDirector_Eip | grep ^public_ip`) from the terraform.tfstate file and modify the iaas.json
6. Make copy of cloud-config-aws.yml.example and make necessary changes.
7. Run `./create-bosh.sh -c ./config -o . -i aws -u XXXXXXXXXXXXXXXXXXXX -p "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"`

# Usage

create-bosh.sh expects that a cloud-config.yml and iaas.json exist in the configuration
directory. The iaas.json contains the IaaS specific configuration for BOSH. The
iaas..aws.stub.json can be used as an example. The cloud-config.yml will be loaded into the newly created BOSH director.

Arguments:  
+ -c <config directory> - The directory where configuration files are stored.  
+ -o <deployment directory> - The directory where generated files are stored. The thought is, this directory would be persisted in an object store, github or something form of persistence.  
+ -i <IaaS> - the IaaS BOSH will be deployed to.  
+ -u <IaaS user> - IaaS user with permissions to perform a deployment.  
+ -p <IaaS password> - password for the IaaS user.  
+ -d - use this option to delete a deployment.  
