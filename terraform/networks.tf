provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  #shared_credentials_file = "${var.credentialsfile}"
  region     = var.region
}
resource "aws_vpc" "terraformmain" {
    cidr_block = var.vpc-fullcidr
   #### this 2 true values are for use the internal vpc dns resolution
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name = "vpc_devops"
    }
}

resource "aws_s3_bucket" "terrafrom-state" {
    bucket = "terrafrom-state"
    
    lifecycle {
        prevent_destroy = true
    }

    versioning {
        enabled = true
    }

server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
 }

terraform {
  required_version = ">= 0.12, < 0.13"

  backend "s3" {
    bucket = "terrafrom-state"
    key = "aws-devops/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
