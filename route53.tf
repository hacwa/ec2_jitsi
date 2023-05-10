#resource "aws_route53domains_registered_domain" "hacwa_com_domain" {
#  domain_name = var.hacwa_com
#  transfer_lock = false
#  name_server {
#    name = "ns-195.awsdns-24.com"
#  }
#  name_server {
#    name = "ns-874.awsdns-45.net"
#  }
#  tags = {
#    Environment = "hacwa_com"
#  }
#}

resource "aws_route53_zone" "primary" {
  name = var.hacwa_com
}



resource "aws_route53_record" "site_domain" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.jitsi_record_name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.jitsi_node.public_ip]
  depends_on = [ aws_instance.jitsi_node ]
}
#  alias {
#    name                   = 
#    zone_id                = 
#    evaluate_target_health = 
#  }
#}

#data "aws_route53_zone" "hacwa_com_zone" {
#  name = var.hacwa_com
#  private_zone = false
#  depends_on = [ aws_route53_zone.primary ]
#}
#####

