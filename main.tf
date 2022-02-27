terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.47.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

variable "instance_name" {
  default = "aws_cloud"
}

resource "aws_instance" "vm" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"
  key_name = aws_key_pair.login.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_egress.id]

  tags = {
    Name = var.instance_name
  }

} 

output "instance_ip_addr" {
  value = ["${aws_instance.vm.*.public_ip}"]
}


resource "aws_key_pair" "login" {
  key_name = "login"
  public_key = file("../secs/ssh.aws.mars.keyfile.pub")
}


resource "aws_security_group" "allow_ssh_egress" {
  name        = "allow_ssh_egress"
  description = "Allow ssh inbound traffic and required outbound"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["84.255.203.251/32"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "local_file" "hosts_cfg" {
  content = templatefile("./templates/hosts.tpl",
    {
      hosts = aws_instance.vm.*.public_ip
    }
  )
  filename = "./ansible/inventory/hosts.cfg"
}

