terraform {
  backend "s3" {
    bucket = "com-ramirocuenca-terraform-states"
    key    = "foundations/state"
    region = "us-east-1"
  }
}