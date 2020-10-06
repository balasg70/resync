Module Input Variables

name - the base name used on all module resources as an identifier (default RDS_BOOSTRAP_EPHEMERAL)

subnet_id - the subnet in which the ephemeral instance will be launched

security_group_ids - a list of security groups the ephemeral instance will belong to (use it to allow access to the RDS cluster), default []

iam_instance_profile - instance profile name that will be used by the bootstrap instance

endpoint - your RDS connection endpoint

port - your RDS connection port

master_username - your RDS cluster master user name

master_password - your RDS cluster master user password

database - your database name

shell_script - (optional) a shell script template that will be run from the ephemeral instance (details below)

sql_script - (optional) a SQL script that will be run from the ephemeral instance against a MySQL/Aurora RDS DB

instance_type - (optional, default t2.micro) ephemeral instance type

A Terraform module to create an Amazon Web Services (AWS) RDS MYSQL .

## Usage

This module creates a RDS alongside a variety of related resources,


- RDS Instance resources
- DB Root Volumen Block
- Mysql scripts

After running this terraform modules, Need to restart the RDS services on AWS cloud. 

To run this example you need to execute:

$ terraform init

$ terraform plan

$ terraform apply

