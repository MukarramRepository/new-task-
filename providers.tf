terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-9700" # Replace with your bucket name
    key            = "dev/terraform.tfstate"   # Replace with your desired key
    region         = "ap-south-1"              # Replace with your region
    dynamodb_table = "tf-lock-table"           # Replace with your DynamoDB lock table
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-south-1" 
}
