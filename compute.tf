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
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_access_role.name
  vpc_security_group_ids      = [aws_security_group.jitsi_sg.id]
  subnet_id                   = aws_subnet.jitsi_subnet.id
 root_block_device {
   volume_type           = "gp2"
   volume_size           = "10"
   delete_on_termination = true
  }
  user_data            = <<-EOF
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common unzip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
apt-get install -y docker-ce
usermod -aG docker ubuntu
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-8615.zip
unzip stable-8615.zip
echo "LETSENCRYPT_EMAIL=admin@hacwa.co.uk" >> /root/docker-jitsi-meet-stable-8615/.env
echo "ENABLE_LETSENCRYPT=1" >> /root/docker-jitsi-meet-stable-8615/.env
echo "LETSENCRYPT_DOMAIN=jitsi.hacwa.com" >> /root/docker-jitsi-meet-stable-8615/.env
echo "LETSENCRYPT_USE_STAGING=1" >> /root/docker-jitsi-meet-stable-8615/.env
echo "PUBLIC_URL=https://jitsi.hacwa.com" >> /root/docker-jitsi-meet-stable-8615/.env
sed -i s/8443/443/ /root/docker-jitsi-meet-stable-8615/.env
sed -i s/8000/80/ /root/docker-jitsi-meet-stable-8615/.env
/root/docker-jitsi-meet-stable-8615/gen-passwords.sh
docker-compose up -d /root/docker-jitsi-meet-stable-8615/docker-compose.yaml
EOF

}








