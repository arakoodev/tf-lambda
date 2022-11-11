terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAQONAGN"
  secret_key = "pfmc"

}
