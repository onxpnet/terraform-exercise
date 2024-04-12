variable "region" {
  description = "Region of project"
  type = string
}

variable "mysql_version" {
  description = "MySQL's version"
  type = string
}
 
variable "size" {
  description = "Disk Size"
  type = number
}

variable "backup_retention" {
  description = "Disk Size"
  type = number
}

variable "network_id" {
  description = "VPC ID"
  type = string
}

 