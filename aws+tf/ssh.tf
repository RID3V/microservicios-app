resource "aws_key_pair" "webkey" {
  key_name   = "webkey"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVtLWei5itiZfJhYwRp/HIu7Q1Q21gdHkLiTOMYhXdy rid@limpio"
}