terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.65.0"
    }
  }
        backend "s3" {
    }

}

#provider "aws" {
#  region     = "eu-west-2"
#}

#'#'#
