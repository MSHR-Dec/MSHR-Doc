locals {
  name = "ubuntu"
}

module "vpc" {
  source = "./modules/vpc"

  name = local.name
  cidr = "10.0.0.0/16"

  public_subnet = {
    public-a = {
      cidr = "10.0.0.0/24"
      az   = "ap-northeast-1a"
    }
  }
}

module "sg" {
  source = "./modules/sg"

  name        = local.name
  description = "Security Group for Ubuntu"
  vpc_id      = module.vpc.id
}

module "ec2" {
  source = "./modules/ec2"

  ami      = data.aws_ami.ubuntu.id
  name     = local.name
  key_name = "ubuntu"

  kubernetes_version = "1.29"
  containerd_version = "1.7.15"
  runc_version       = "1.1.12"
  cni_version        = "1.4.1"

  sg_ids = [
    module.sg.id
  ]

  instance = {
    control-plane-1 = {
      subnet_id = module.vpc.public_subnet_id["public-a"]
    }
  }
}
