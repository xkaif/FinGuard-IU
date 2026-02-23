variable "iam_users" {
  description = "IAM-Benutzer für FinGuard-DevOps"
  type        = list(string)
  default     = ["finguard-dev1", "finguard-dev2"]
}

resource "aws_iam_user" "devops" {
  for_each = toset(var.iam_users)
  name     = each.value
}

resource "aws_iam_group" "finguard_devops" {
  name = "FinGuard-DevOps"
  path = "/"
}

resource "aws_iam_group_membership" "devops" {
  name  = "FinGuard-DevOps-members"
  group = aws_iam_group.finguard_devops.name
  users = [for u in aws_iam_user.devops : u.name]
}

resource "aws_iam_group_policy" "devops" {
  name  = "FinGuard-DevOps-Policy"
  group = aws_iam_group.finguard_devops.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2ReadAndManage"
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "elasticloadbalancing:Describe*",
          "autoscaling:Describe*"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.project_name}-*",
          "arn:aws:s3:::${var.project_name}-*/*"
        ]
      },
      {
        Sid      = "CloudWatchRead"
        Effect   = "Allow"
        Action   = ["cloudwatch:Describe*", "cloudwatch:Get*", "cloudwatch:List*", "logs:Get*", "logs:Describe*", "logs:FilterLogEvents"]
        Resource = "*"
      },
      {
        Sid      = "CloudTrailRead"
        Effect   = "Allow"
        Action   = ["cloudtrail:LookupEvents", "cloudtrail:GetTrailStatus", "cloudtrail:DescribeTrails"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_app" {
  name               = "FinGuard-EC2-App-Role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "ec2_app" {
  name = "FinGuard-EC2-App"
  role = aws_iam_role.ec2_app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.app.arn,
          "${aws_s3_bucket.app.arn}/*"
        ]
      },
      {
        Sid      = "KMS"
        Effect   = "Allow"
        Action   = ["kms:Decrypt", "kms:GenerateDataKey"]
        Resource = ["*"]
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.app.arn}:*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_app" {
  name = "FinGuard-EC2-App-Profile"
  role = aws_iam_role.ec2_app.name
}
