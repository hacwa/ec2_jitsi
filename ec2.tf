data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu-pro-server/images/hvm-ssd/ubuntu-focal-20.04-amd64-pro-server-*"]
  }
}
resource "aws_instance" "jitsi_node" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.server_ami.id
#  user_data = <<-EOF
#  EOF
  network_interface {
    network_interface_id = aws_network_interface.jitsi_network_interface.id
    device_index         = 0
  }  
  root_block_device {
    volume_size = 10
 }
}
resource "aws_eip" "ip" {
  instance = aws_instance.jitsi_node.id
  vpc      = true
}