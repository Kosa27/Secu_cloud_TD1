variable "my_ip" {
  description = "Ton IP publique en /32"
  type        = string
}

variable "subnet_id" {
  description = "Sous-réseau par défaut"
  type        = string
}

variable "ami" {
  description = "AMI Amazon Linux 2023"
  type        = string
}

variable "keypair" {
  description = "Nom de ta paire de clés EC2"
  type        = string
}
