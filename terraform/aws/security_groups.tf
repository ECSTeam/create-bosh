/*
  Security Group Definitions
*/
# Security Group for NAT
resource "aws_security_group" "nat_instance_sg" {
    name = "${var.environment}-nat_instance_sg"
    description = "${var.environment} NAT Instance Security Group"
    vpc_id = "${aws_vpc.BoshVpc.id}"
    tags {
        Name = "${var.environment}-NAT intance security group"
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["${var.bosh_vpc_cidr}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "directorSG" {
    name = "bosh-director-sg"
    description = "Allow incoming connections for Bosh Director."
    vpc_id = "${aws_vpc.BoshVpc.id}"
    tags {
        Name = "${var.environment}-Bosh Director Security Group"
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["${var.bosh_vpc_cidr}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.bosh_vpc_cidr}"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        self = true
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "directorSGOffice" {
    name = "bosh-director-sg-office"
    description = "Allow incoming connections for Bosh Director."
    vpc_id = "${aws_vpc.BoshVpc.id}"
    tags {
        Name = "${var.environment}-Bosh Director Security Group"
    }
    ingress {
        from_port = 25555
        to_port = 25555
        protocol = "tcp"
        cidr_blocks = ["${var.my_public_ip_cidr}"]
    }
    ingress {
        from_port = 6868
        to_port = 6868
        protocol = "tcp"
        cidr_blocks = ["${var.my_public_ip_cidr}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.my_public_ip_cidr}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group_rule" "directorSG-office" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["${var.my_public_ip_cidr}"]

  security_group_id = "${aws_security_group.directorSG.id}"
}
