# -------------------------------------------------------------
# VPC
# -------------------------------------------------------------
resource "aws_vpc" "portfolio_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true       # DNS解決
  enable_dns_hostnames = true       # DNSホスト名付与
  assign_generated_ipv6_cidr_block = false        # IPv6割当
  instance_tenancy = "default"

  tags = {
    Name = "portfolio-vpc"
  }
}