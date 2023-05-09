terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
  backend "s3"{
      region = "us-east-2"
      bucket = "oidc-jitsi"
      key = "jitsi.tfstate"
      }
}
provider "aws" {
  region = "eu-west-2"
}



