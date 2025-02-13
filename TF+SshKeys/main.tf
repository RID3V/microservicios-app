provider "aws" {
  region = var.region
}

resource "aws_security_group" "sshaut" {
  name        = "prupo sshsolo"
  description = "allow ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}

resource "aws_key_pair" "mi_clave_ssh" {
  key_name   = "missh"
  public_key = local_file.public_key.content
  depends_on = [local_file.private_key, local_file.public_key]
}

resource "aws_instance" "mi_ec2" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = aws_key_pair.mi_clave_ssh.key_name
  security_groups      = [aws_security_group.sshaut.name]
  associate_public_ip_address = true

  tags = {
    Name = "web"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"  
      private_key = local_file.private_key.content 
      host        = self.public_ip
    }
  }

  depends_on = [aws_key_pair.mi_clave_ssh] 
}
