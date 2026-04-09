variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "secure-static-site"
}

variable "domain_name" {
  default = "sitaram.icu"
}

variable "vpc_id" {
    default = "vpc-0f706674c826a3ec9"

}

variable "subnets" {
  type = list(string)
  default = [ "subnet-083b823a64d263df4","subnet-0ce0f1be5621b0da4" ]
}

variable "zone_id" {
    default = "Z09532653LYSJAOMBYJTE"
}
variable "ami_id" {
    default = "ami-0220d79f3f480ecf5"
}
