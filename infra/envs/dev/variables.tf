variable "project_name" {
  description = "Project name"
  type        = string
  default     = "tripare"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_class" {
  description = "Database instance class"
  type        = string
}

variable "backup_retention" {
  description = "Backup retention days"
  type        = number
}

variable "deletion_protection" {
  description = "Deletion protection"
  type        = bool
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}
