# FinGuard – Terraform (Infrastructure as Code)

Dieses Verzeichnis enthält die Terraform-Konfiguration für die **FinGuard Financial Transaction Platform** gemäß Projektbericht und Technische_Architektur (PoC, Free Tier, 1 USD Budget).

## Voraussetzungen

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- AWS CLI konfiguriert (`aws configure`) oder Umgebungsvariablen `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`
- Ein AWS-Account mit Berechtigungen für die genutzten Services (IAM, VPC, EC2, ALB, S3, CloudWatch, CloudTrail, Budgets, SNS, ACM)

## Schnellstart

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Abgedeckte Komponenten

| Komponente | Beschreibung |
|------------|--------------|
| **IAM** | Gruppe `FinGuard-DevOps`, EC2 Instance Role (S3, KMS, CloudWatch Logs) |
| **VPC** | Custom VPC, öffentliche/private Subnets, Internet Gateway, NAT Gateway, NACLs |
| **Security Groups** | ALB: 80/443; EC2: nur vom ALB |
| **EC2** | Amazon Linux 2023, t3.micro, EBS verschlüsselt (KMS), private Subnets |
| **ALB** | Application Load Balancer, Target Group, HTTP-Listener (optional HTTPS mit ACM) |
| **Auto Scaling** | Min 1, Max 4, Skalierung nach CPU |
| **S3** | App-Bucket und CloudTrail-Bucket, SSE-KMS, Block Public Access |
| **CloudWatch** | Log Groups (90 Tage), Dashboard, Alarme (CPU, 5xx), SNS |
| **CloudTrail** | Management-Events, S3-Logging, Log Validation |
| **Budget** | 1 USD, Alarme bei 80 % und 100 % (E-Mails optional) |

## Wichtige Variablen

- `aws_region` – z. B. `eu-central-1`
- `budget_emails` – Liste von E-Mails für Budget- und Alarm-Benachrichtigungen (SNS-Abo muss per E-Mail bestätigt werden)
- `domain_name` – optional; für PoC leer lassen. Dann erreichst du die App per **HTTP** unter der ALB-URL (z. B. `http://finguard-poc-alb-….eu-central-1.elb.amazonaws.com`). Nur bei eigener Domain: HTTPS mit ACM (DNS-Validierung).

## Hinweise

- **MFA** für Console-Benutzer wird in der AWS Console pro IAM-User konfiguriert (nicht per Terraform).
- **AWS Shield Standard** ist am ALB automatisch aktiv (keine Konfiguration nötig).
- **Ohne Domain (PoC):** ALB ist über die AWS-DNS-URL auf Port 80 (HTTP) erreichbar. HTTPS braucht eine eigene Domain und ACM-Validierung.
- **Terraform State**: Standardmäßig lokal; für Team/Produktion Backend (z. B. S3 + DynamoDB) in `versions.tf` eintragen.

## Outputs nach `apply`

- `alb_dns_name` – Aufruf der Anwendung: `http://<alb_dns_name>`
- `s3_app_bucket`, `s3_cloudtrail_bucket` – Bucket-Namen
- `acm_certificate_validation` – CNAME-Einträge für ACM, falls `domain_name` gesetzt
