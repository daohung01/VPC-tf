resource "aws_key_pair" "sshkey" {
  key_name = "publickey"
  public_key = var.ssh_public_key
}
