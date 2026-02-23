variable "aws_region" {
  description = "AWS-Region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Projektname"
  type        = string
  default     = "finguard"
}

variable "environment" {
  description = "Umgebung"
  type        = string
  default     = "poc"
}

variable "vpc_cidr" {
  description = "CIDR-Block der VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR-Blöcke öffentliche Subnets (mind. 2 AZs für ALB)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR-Blöcke private Subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "app_port" {
  description = "Port der Backend-Anwendung"
  type        = number
  default     = 8080
}

variable "asg_min_size" {
  description = "Min. EC2-Instanzen"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Max. EC2-Instanzen"
  type        = number
  default     = 4
}

variable "budget_amount_usd" {
  description = "AWS-Budget in USD"
  type        = string
  default     = "1"
}

variable "budget_emails" {
  description = "E-Mail-Adressen für Budget- und Alarm-Benachrichtigungen"
  type        = list(string)
  default     = ["kai@wescript.de"]
}

variable "cloudwatch_log_retention_days" {
  description = "Aufbewahrung CloudWatch Logs in Tagen"
  type        = number
  default     = 90
}

variable "domain_name" {
  description = "Domain für HTTPS/ACM. Leer = nur HTTP über ALB-DNS."
  type        = string
  default     = ""
}
