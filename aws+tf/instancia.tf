provider "aws" {
  region = "us-east-1"
  
}

resource "aws_instance" "web" {
  ami                     = "ami-04b4f1a9cf54c11d0"
  instance_type           = "t2.micro"
    key_name                = "webkey"
  vpc_security_group_ids = [ aws_security_group.grupoweb.id ]
  availability_zone = "us-east-1a"  
  tags = {
    Name = "web"
  }
  provisioner "file" {
    source      = "a.sh"
    destination = "/tmp/a.sh"
        
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("id")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/a.sh",
      "sudo /tmp/a.sh"
    ]
  }
}