variable "domain_name" {
  type = string
  default = "rifnology.com"
}
variable "ttl"{
    type = string
    default = "300"
}
variable "function_name"{
    type = string
    # this is the name of your lambda
    default = "lambda2"
}
variable "bucket_name"{
    type = string
    default = "lambda-bucket"
}
variable "zone_id"{
    type = string
    default = "Z0721641H0XADS2MTUFI"
}