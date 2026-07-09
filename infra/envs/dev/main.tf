module "network" {

  source = "../../modules/network"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

module "ecs" {

  source = "../../modules/ecs"

  project_name = var.project_name

  aws_region = var.aws_region

  vpc_id = module.network.vpc_id

  private_subnet_ids = module.network.private_subnet_ids

  execution_role_arn = "arn:aws:iam::217441067604:user/terraform-user"
}

module "rds" {

  source = "../../modules/rds"

  project_name = var.project_name

  vpc_id = module.network.vpc_id

  private_subnet_ids = module.network.private_subnet_ids

  ecs_security_group_id = module.ecs.security_group_id

  username = var.db_username

  password = var.db_password

  instance_class = var.instance_class

  backup_retention_period = var.backup_retention

  deletion_protection = var.deletion_protection
}
