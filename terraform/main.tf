provider "aws" {
    region = "ap-south-1"
}

output "name" {
  value = fileexists("${path.module}/init.sh")
}

data "aws_key_pair" "key-pair" {
    key_name = "one2n-assignment-keypair"
}

# Create a VPC for our infrastructure
resource "aws_vpc" "vpc" {
    cidr_block = "172.31.0.0/20"
    tags = {
      Name = "assignment-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    depends_on = [ aws_vpc.vpc ]
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.31.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "assignment-vpc-subnet"
    }
}

resource "aws_internet_gateway" "internet-gateway" {
    depends_on = [ aws_vpc.vpc ]
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route-table" {
    depends_on = [ aws_vpc.vpc, aws_internet_gateway.internet-gateway ]
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "172.31.0.0/20"
        gateway_id = "local"
    }
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gateway.id
    }
}

resource "aws_route_table_association" "assocation" {
    depends_on = [ aws_subnet.public_subnet, aws_route_table.route-table ]
    route_table_id = aws_route_table.route-table.id
    subnet_id = aws_subnet.public_subnet.id
}

# Create a security group
resource "aws_security_group" "security-group" {
    depends_on = [ aws_vpc.vpc ]
    name = "assignment-sg-test"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "assignment-sg-test"
    }
}

# Create a role for use with ec2 instance
resource "aws_iam_role" "ec2-ssm-role" {
    name = "assignment-ec2-ssm-role"
    assume_role_policy = jsonencode({
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
}

resource "aws_iam_role_policy_attachment" "role-attachment" {
    role = aws_iam_role.ec2-ssm-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# IAM instance profile for attaching iam role to ec2 instance
resource "aws_iam_instance_profile" "instance-profile" {
    name = "ec2-ssm-profile"
    role = aws_iam_role.ec2-ssm-role.name  
}

resource "aws_instance" "assignment_instance" {
    ami = var.ami_id
    instance_type = "t2.micro"
    key_name = data.aws_key_pair.key-pair.key_name

    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.security-group.id]

    root_block_device {
        delete_on_termination = true
        volume_type = "gp2"
        volume_size = 8
    }

    iam_instance_profile = aws_iam_instance_profile.instance-profile.name
    user_data = file("${path.module}/init.sh")
    tags = {
        Name = "one2n-assignment"
    }
}