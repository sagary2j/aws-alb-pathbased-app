# Terraform AWS Application Load Balancer (ALB) Outputs
output "alb_id" {
  description = "The ID and ARN of the Application load balancer we created."
  value       = aws_alb.alb.id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_alb.alb.dns_name
}

output "alb_arn" {
  description = "The ID and ARN of the Application load balancer we created."
  value       = aws_alb.alb.arn
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = aws_alb_listener.alb-listener.id
}
