variable "region" {
  default = "ap-southeast-1"
}
variable "AmiLinux" {
  type = map
  default = {
    eu-west-2 = "t2.micro"
    eu-west-1 = "t2.micro"
    us-east-1 = "t2.micro"
  }
}

variable "aws_access_key" {
  default = "AKIAJUU5FDJ4B6ZWTCFA"
  description = "the user aws access key"
}

variable "aws_secret_key" {
  default = "FQB/v33sMjsKwMsU+Wwv2Fng6zzayJZeNif+XaXX"
  description = "the user aws secret key"
}
variable "vpc-fullcidr" {
    default = "172.16.0.0/16"
  description = "the vpc cdir"
}
variable "Subnet-Public-AzA-CIDR" {
  default = "172.16.0.0/24"
  description = "the cidr of the subnet"
}
variable "Subnet-Private-AzA-CIDR" {
  default = "172.16.3.0/24"
  description = "the cidr of the subnet"
}
variable "key_name" {
  default = "demotest"
  description = "the ssh key to use in the EC2 machines"
}
variable "DnsZoneName" {
  default = "ShaanAWSDNS.internal"
  description = "the internal dns name"
}
#variable "kp_devops" {
#  type        = string
#  description = "EC2 Key pair name for the EC2"
#}

variable "server_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = "3000"
}

variable "elb_port" {
  description = "The port the elb will be listening"
  type        = number
  default     = "80"
}
