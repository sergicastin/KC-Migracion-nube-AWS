output "kc-nginx_endpoint-sergi" {
  description = "Endpoint del servicio Nginx"

  value = aws_lb.kc-nginx_lb-sergi.dns_name
}
