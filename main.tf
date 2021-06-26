
provider "aws" {
access_key = "${var.aws_access_key}"
secret_key = "${var.aws_secret_key}"
region     = "${var.region}"
}

terraform {
  backend "s3" {}
}

module "vpc" {
  source = "../terraform-docker/modules/vpc"
}

module "public_subnet" {
  source = "../terraform-docker/modules/public-subnet"

  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "../terraform-docker/modules/internet-gateway"

  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "../terraform-docker/modules/route-table"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_id    = module.public_subnet.public_subnet_id
}

module "ec2" {
  source = "../terraform-docker/modules/ec2"
  ec2_name = "testedocker"
  vpc_id                  = module.vpc.vpc_id
  public_subnet_id        = module.public_subnet.public_subnet_id

  ec2_ssh_key_name        = var.ec2_ssh_key_name
  ec2_ssh_public_key_path = var.ec2_ssh_public_key_path
}