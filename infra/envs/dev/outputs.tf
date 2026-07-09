output "vpc_id" {
  value = module.network.vpc_id
}

output "ecs_cluster" {
  value = module.ecs.cluster_name
}

output "database_endpoint" {
  value = module.rds.endpoint
}
