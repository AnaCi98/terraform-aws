# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

#Configure data AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#Configure Instance resource
resource "aws_instance" "example" {
	ami = data.aws_ami.ubuntu.id
	instance_type = "t2.micro"
    key_name = "terraform-key"
	user_data = "${file("script.sh")}"
				
	tags = {
		Name = "My first EC2 using Terraform"
	}
	vpc_security_group_ids = [aws_security_group.instance.id]
}

#Configure Security Group
resource "aws_security_group" "instance" {
	name = "terraform-tcp-security-group"
 
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
    
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


output "public_ip" {
  value       = aws_instance.example.public_ip
}
