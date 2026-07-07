variable "instance_class" {
  description = "Database instance class"
  type        = string
}

variable "backup_retention" {
  description = "Number of days to retain backups"
  type        = number
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
}
