/*
  For Region
*/
resource "aws_vpc" "BoshVpc" {
    cidr_block = "${var.bosh_vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.environment}-terraform-pcf-vpc"
    }
}
/* create elastic ip for bosh director*/
resource "aws_eip" "BoshDirector_Eip" {
  vpc      = true
}


/* create elastic ips for nat instance - required to allow outbound internet access  */
resource "aws_eip" "BoshVpcNatInsEip_az1" {
  vpc      = true
}

# Create Public Subnet - for bosh director and concourse web vms
resource "aws_subnet" "BoshVpcPublicSubnet_az1" {
    vpc_id = "${aws_vpc.BoshVpc.id}"

    cidr_block = "${var.public_subnet_cidr_az1}"
    availability_zone = "${var.az1}"

    tags {
        Name = "${var.environment}-BoshVpc Public Subnet AZ1"
    }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.BoshVpcNatInsEip_az1.id}"
  subnet_id = "${aws_subnet.BoshVpcPublicSubnet_az1.id}"
  tags {
    Name = "${var.environment}-NAT"
  }
}
resource "aws_internet_gateway" "inet_gw" {
  vpc_id = "${aws_vpc.BoshVpc.id}"

  tags {
    Name = "${var.environment}-main"
  }
}

resource "aws_route_table" "PublicSubnetRouteTable" {
    vpc_id = "${aws_vpc.BoshVpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.inet_gw.id}"
    }

    tags {
        Name = "${var.environment}-Public Subnet Route Table"
    }
}

resource "aws_route_table_association" "a_az1" {
    subnet_id = "${aws_subnet.BoshVpcPublicSubnet_az1.id}"
    route_table_id = "${aws_route_table.PublicSubnetRouteTable.id}"
}



/* concourse resources */


resource "aws_eip" "concourse_web_Eip" {
  vpc      = true
}
resource "aws_subnet" "ConcourseVpcPrivateSubnet_az1" {
    vpc_id = "${aws_vpc.BoshVpc.id}"

    cidr_block = "${var.concourse_private_subnet_cidr_az1}"
    availability_zone = "${var.az1}"

    tags {
        Name = "${var.environment}-Concourse Private Subnet AZ1"
    }
}
resource "aws_route_table" "ConcoursePrivateSubnetRouteTable" {
    vpc_id = "${aws_vpc.BoshVpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }

    tags {
        Name = "${var.environment}-Concourse Subnet Route Table"
    }
}

resource "aws_route_table_association" "concourse_az1" {
    subnet_id = "${aws_subnet.ConcourseVpcPrivateSubnet_az1.id}"
    route_table_id = "${aws_route_table.ConcoursePrivateSubnetRouteTable.id}"
}
