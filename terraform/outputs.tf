output "alb_dns_name" {
  description = "ALB DNS-Name"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "ALB Route53 Zone ID"
  value       = aws_lb.main.zone_id
}

output "s3_app_bucket" {
  description = "App-S3-Bucket"
  value       = aws_s3_bucket.app.id
}

output "s3_cloudtrail_bucket" {
  description = "CloudTrail-S3-Bucket"
  value       = aws_s3_bucket.cloudtrail.id
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.app.name
}

output "asg_name" {
  description = "Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "vpc_id" {
  description = "VPC-ID"
  value       = aws_vpc.main.id
}

output "acm_certificate_validation" {
  description = "ACM DNS-Validierung (nur bei gesetzter domain_name)"
  value = (
    var.domain_name != ""
    ? [for dvo in aws_acm_certificate.alb[0].domain_validation_options : { name = dvo.resource_record_name, value = dvo.resource_record_value }]
    : []
  )
}

output "sns_topic_arn" {
  description = "SNS-Topic für Alarme"
  value       = aws_sns_topic.alerts.arn
}
