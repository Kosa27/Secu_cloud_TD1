############################################
# Provider AWS (OBLIGATOIRE)
############################################

provider "aws" {
  region = "eu-west-3"
}

############################################
# VPC par défaut
############################################

data "aws_vpc" "default" {
  default = true
}

############################################
# Subnet choisi
############################################

data "aws_subnet" "selected" {
  id = var.subnet_id
}

############################################
# Security Group BASTION (EXISTANT)
############################################

data "aws_security_group" "bastion" {
  id = "sg-02014976a0847c226"
}

############################################
# Security Group CIBLE (EXISTANT)
############################################

data "aws_security_group" "cible" {
  id = "sg-0625150d313f1491b"
}

############################################
# Instance BASTION
############################################

resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [data.aws_security_group.bastion.id]
  key_name                    = var.keypair

  # IMPORTANT : IP PUBLIQUE
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}

############################################
# Instance CIBLE
############################################

resource "aws_instance" "cible" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [data.aws_security_group.cible.id]
  key_name                    = var.keypair

  tags = {
    Name = "cible"
  }
}

############################################
# INVENTAIRE ANSIBLE
############################################

data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")

  vars = {
    bastion_ip = aws_instance.bastion.public_ip
    cible_ip   = aws_instance.cible.private_ip
  }
}

resource "local_file" "inventory" {
  content  = data.template_file.inventory.rendered
  filename = "${path.module}/inventory.ini"
}
