variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "vpc_azs" {
  type = list(string)
}

variable "private_subnets" {
  type = object({
    list = list(string)
    inbound_acl_rules = optional(list(object({
      rule_number = string
      protocol    = string
      from_port   = string
      to_port     = string
      cidr_block  = string
      rule_action = string
    })), [])
    outbound_acl_rules = optional(list(object({
      rule_number = string
      protocol    = string
      from_port   = string
      to_port     = string
      cidr_block  = string
      rule_action = string
    })), [])
  })
  default = {
    list               = []
    inbound_acl_rules  = []
    outbound_acl_rules = []
  }
}

variable "public_subnets" {
  type = object({
    list = list(string)
    inbound_acl_rules = optional(list(object({
      rule_number = string
      protocol    = string
      from_port   = string
      to_port     = string
      cidr_block  = string
      rule_action = string
    })), [])
    outbound_acl_rules = optional(list(object({
      rule_number = string
      protocol    = string
      from_port   = string
      to_port     = string
      cidr_block  = string
      rule_action = string
    })), [])
  })
  default = {
    list               = []
    inbound_acl_rules  = []
    outbound_acl_rules = []
  }
}
