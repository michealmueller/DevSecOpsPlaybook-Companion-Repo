# AWS Secrets Manager Configuration with Terraform
# This configuration demonstrates secure secrets management for AWS-based applications

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data source for current AWS region
data "aws_region" "current" {}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# KMS key for encrypting secrets
resource "aws_kms_key" "secrets_key" {
  description             = "KMS key for encrypting secrets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "secrets-encryption-key"
    Environment = var.environment
    Purpose     = "secrets-management"
  }
}

resource "aws_kms_alias" "secrets_key_alias" {
  name          = "alias/secrets-${var.environment}"
  target_key_id = aws_kms_key.secrets_key.key_id
}

# Application secrets
resource "aws_secretsmanager_secret" "app_database_password" {
  name                    = "${var.app_name}-database-password"
  description             = "Database password for ${var.app_name}"
  kms_key_id             = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.app_name}-database-password"
    Environment = var.environment
    Type        = "database"
  }
}

resource "aws_secretsmanager_secret_version" "app_database_password" {
  secret_id     = aws_secretsmanager_secret.app_database_password.id
  secret_string = jsonencode({
    username = var.database_username
    password = var.database_password
    host     = var.database_host
    port     = var.database_port
    database = var.database_name
  })
}

# API keys and tokens
resource "aws_secretsmanager_secret" "app_api_keys" {
  name                    = "${var.app_name}-api-keys"
  description             = "API keys and tokens for ${var.app_name}"
  kms_key_id             = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.app_name}-api-keys"
    Environment = var.environment
    Type        = "api-keys"
  }
}

resource "aws_secretsmanager_secret_version" "app_api_keys" {
  secret_id     = aws_secretsmanager_secret.app_api_keys.id
  secret_string = jsonencode({
    github_token    = var.github_token
    slack_webhook   = var.slack_webhook
    external_api_key = var.external_api_key
  })
}

# JWT signing key
resource "aws_secretsmanager_secret" "app_jwt_key" {
  name                    = "${var.app_name}-jwt-signing-key"
  description             = "JWT signing key for ${var.app_name}"
  kms_key_id             = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.app_name}-jwt-signing-key"
    Environment = var.environment
    Type        = "jwt-key"
  }
}

resource "aws_secretsmanager_secret_version" "app_jwt_key" {
  secret_id     = aws_secretsmanager_secret.app_jwt_key.id
  secret_string = var.jwt_signing_key
}

# IAM role for applications to access secrets
resource "aws_iam_role" "secrets_access_role" {
  name = "${var.app_name}-secrets-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Name        = "${var.app_name}-secrets-access-role"
    Environment = var.environment
  }
}

# IAM policy for accessing specific secrets
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "${var.app_name}-secrets-access-policy"
  description = "Policy for accessing application secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.app_database_password.arn,
          aws_secretsmanager_secret.app_api_keys.arn,
          aws_secretsmanager_secret.app_jwt_key.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = [
          aws_kms_key.secrets_key.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_access_policy_attachment" {
  role       = aws_iam_role.secrets_access_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
}

# IAM role for CI/CD pipeline to manage secrets
resource "aws_iam_role" "cicd_secrets_role" {
  name = "${var.app_name}-cicd-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.app_name}-cicd-secrets-role"
    Environment = var.environment
  }
}

# IAM policy for CI/CD to update secrets
resource "aws_iam_policy" "cicd_secrets_policy" {
  name        = "${var.app_name}-cicd-secrets-policy"
  description = "Policy for CI/CD to manage secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:UpdateSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.app_database_password.arn,
          aws_secretsmanager_secret.app_api_keys.arn,
          aws_secretsmanager_secret.app_jwt_key.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = [
          aws_kms_key.secrets_key.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cicd_secrets_policy_attachment" {
  role       = aws_iam_role.cicd_secrets_role.name
  policy_arn = aws_iam_policy.cicd_secrets_policy.arn
}

# CloudWatch log group for secrets access monitoring
resource "aws_cloudwatch_log_group" "secrets_access_logs" {
  name              = "/aws/secretsmanager/${var.app_name}"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-secrets-access-logs"
    Environment = var.environment
  }
}

# CloudWatch metric filter for failed secret access
resource "aws_cloudwatch_log_metric_filter" "failed_secret_access" {
  name           = "${var.app_name}-failed-secret-access"
  log_group_name = aws_cloudwatch_log_group.secrets_access_logs.name
  pattern        = "[timestamp, request_id, error_code=\"AccessDenied\"]"

  metric_transformation {
    name      = "FailedSecretAccess"
    namespace = "SecretsManager"
    value     = "1"
  }
}

# CloudWatch alarm for failed secret access
resource "aws_cloudwatch_metric_alarm" "failed_secret_access_alarm" {
  alarm_name          = "${var.app_name}-failed-secret-access-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FailedSecretAccess"
  namespace           = "SecretsManager"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors failed secret access attempts"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]

  tags = {
    Name        = "${var.app_name}-failed-secret-access-alarm"
    Environment = var.environment
  }
}

# SNS topic for security alerts
resource "aws_sns_topic" "security_alerts" {
  name = "${var.app_name}-security-alerts"

  tags = {
    Name        = "${var.app_name}-security-alerts"
    Environment = var.environment
  }
}

# SNS topic subscription for email alerts
resource "aws_sns_topic_subscription" "security_alerts_email" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Variables
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "database_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "database_host" {
  description = "Database host"
  type        = string
}

variable "database_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "slack_webhook" {
  description = "Slack webhook URL"
  type        = string
  sensitive   = true
}

variable "external_api_key" {
  description = "External API key"
  type        = string
  sensitive   = true
}

variable "jwt_signing_key" {
  description = "JWT signing key"
  type        = string
  sensitive   = true
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository"
  type        = string
}

variable "alert_email" {
  description = "Email for security alerts"
  type        = string
}

# Outputs
output "secrets_manager_arns" {
  description = "ARNs of created secrets"
  value = {
    database_password = aws_secretsmanager_secret.app_database_password.arn
    api_keys         = aws_secretsmanager_secret.app_api_keys.arn
    jwt_key          = aws_secretsmanager_secret.app_jwt_key.arn
  }
}

output "secrets_access_role_arn" {
  description = "ARN of the secrets access role"
  value       = aws_iam_role.secrets_access_role.arn
}

output "cicd_secrets_role_arn" {
  description = "ARN of the CI/CD secrets role"
  value       = aws_iam_role.cicd_secrets_role.arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key for encrypting secrets"
  value       = aws_kms_key.secrets_key.arn
}
