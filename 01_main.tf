# -------------------------------------------------------------
# Terraformのバージョンやプロバイダを指定
# -------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"        # AWS Providerのバージョン
    }
  }

  required_version = ">= 1.8.0"       # Terraform CLIのバージョン
}

# AWSプロバイダの設定
provider "aws" {
  region = "ap-northeast-1"       # 東京リージョン
}