variable "ENV" {}
variable "PROJECT_NAME" {}

variable "VPC_ID" {}
variable "VPC_CIDR" {}
variable "PUBLIC_SUBNETS"  {
    type    = "list"
}
variable "PRIVATE_SUBNETS" {
    type    = "list"
}

variable "AMI_ID" {}