variable "region" {
  description = "us east 1"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de la instancia EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID de la imagen de la instancia (AMI)"
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "key_name" {
  description = "Nombre de la clave SSH para acceder a la instancia"
  default     = "id_rsa"
}

variable "security_group" {
  description = "El grupo de seguridad de la instancia"
  default     = "default"
}

