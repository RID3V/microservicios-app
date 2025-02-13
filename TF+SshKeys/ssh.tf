provider "tls" {
 
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "${path.module}/id_rsa"  
  content  = tls_private_key.example.private_key_pem
}

resource "local_file" "public_key" {
  filename = "${path.module}/id_rsa.pub"  
  content  = tls_private_key.example.public_key_openssh
}

output "private_key_path" {
  value     = local_file.private_key.filename
  sensitive = true
}

output "public_key_path" {
  value = local_file.public_key.filename
}
