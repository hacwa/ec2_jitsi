data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu-pro-server/images/hvm-ssd/ubuntu-focal-20.04-amd64-pro-server-*"]
  }
}
resource "aws_instance" "jitsi_node" {
  instance_type        = "t3.micro"
  ami                  = data.aws_ami.server_ami.id
  iam_instance_profile = aws_iam_instance_profile.ec2_access_role.name
  user_data            = <<-EOF
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common unzip
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo sudo apt-get install -y docker-ce
usermod -aG docker ubuntu

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-8615.zip
sudo unzip stable-8615.zip
sudo cd docker-jitsi-meet-stable-8615/
EOF
  network_interface {
    network_interface_id = module.network.networkinterface
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