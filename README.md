# FinGuard – AWS Infrastructure (Terraform)

Terraform-Konfiguration für die FinGuard Financial Transaction Platform.
Proof of Concept auf AWS mit Free-Tier-Fokus und 1 USD Budgetlimit.

## Architektur

- **VPC** mit öffentlichen und privaten Subnets, NAT Gateway, NACLs
- **EC2** (t3.micro) in privaten Subnets, Auto Scaling (1–4 Instanzen, CPU-basiert)
- **ALB** im öffentlichen Subnet, optional HTTPS via ACM
- **S3** für Anwendungsdaten und CloudTrail-Logs (SSE-KMS, kein Public Access)
- **CloudWatch** Logs, Dashboard, Alarme (CPU, 5xx) mit SNS-Benachrichtigung
- **CloudTrail** für Management-Event-Auditing
- **IAM** mit Least-Privilege EC2 Instance Role
- **Budget** mit Alarmen bei 80 % und 100 %

## Nutzung

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Voraussetzungen: Terraform >= 1.0, konfigurierte AWS CLI.
Details zu Variablen und Outputs stehen in [`terraform/README.md`](terraform/README.md).
