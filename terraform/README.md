# Aws-env-provisioning-with-terraform
This is a template for provisioning a full AWS infrastructure from ground using Terraform.

This repository stores the files for provisioning a production like environment in AWS using Terraform automation which will require us to set up a VPC, Network Gateway, subnets, routes, security groups, an EC2 machine installed inside webapp machine with Apache and its PHP module in a public subnet.


Prerequisites
There are only two prerequisites for this:

1.Terraform – Installation instructions on your desktop to execute this terraform scripts.

2.Free account with AWS. You can register for free Tier AWS account here.

I have used Ubuntu as the OS in this tutorial but instructions should work with any operating system.

Create a Key pair in AWS console with the name Testkey.pem and download it to your local desktop before running
the terraform scripts.

Infrastructure-as-Code

Provision it with Terraform
There are three commands which are pretty much required to provision the infrastructure using Terraform.

$ terraform init 

$ terraform plan

$ terraform apply



