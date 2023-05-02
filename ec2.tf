data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu-pro-server/images/hvm-ssd/ubuntu-focal-20.04-amd64-pro-server-*"]
  }
}

resource "aws_instance" "jitsi_node" {
#  count         = var.instance_count #1
  instance_type = "t3.micro"
#  instance_type = var.instance_type  # t3.micro
  ami           = data.aws_ami.server_ami.id
#  tags = {
#    "Name" = "mtc_node=${random_id.mtc_node_id[count.index].dec}"
  
  root_block_device {
#    volume_size = var.vol_size # 10
    volume_size = 10
 }
}