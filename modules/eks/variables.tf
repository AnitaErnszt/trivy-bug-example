variable "aws_region" {
  type        = string
}

variable "aws_auth_roles" {
  type = list(map(string))
  default = []
}

variable "cluster_version" {
  type        = string
  default     = "1.29"
}

variable "control_plane_subnet_ids" {
  type        = list(string)
  default     = []
}

variable "enabled_log_types" {
  type        = list(string)
  default     = ["authenticator", "controllerManager", "scheduler"]
}

variable "environment" {
  type        = string
}

variable "name" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
}

variable "worker_managed_node_group_machine_types" {
  type        = list(string)
  default     = ["t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge"]
}

variable "worker_managed_node_group_min_size" {
  type        = number
  default     = 2
}

variable "worker_managed_node_group_max_size" {
  type        = number
  default     = 10
}

variable "vpc_id" {
  type        = string
}
