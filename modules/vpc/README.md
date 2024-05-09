<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.48 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.8.1 |

## Resources

| Name | Type |
|------|------|
| [aws_default_network_acl.default_nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_network_acl_rule.private_inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.private_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.public_inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.public_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | n/a | `bool` | `true` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | <pre>object({<br>    list = list(string)<br>    inbound_acl_rules = optional(list(object({<br>      rule_number = string<br>      protocol    = string<br>      from_port   = string<br>      to_port     = string<br>      cidr_block  = string<br>      rule_action = string<br>    })), [])<br>    outbound_acl_rules = optional(list(object({<br>      rule_number = string<br>      protocol    = string<br>      from_port   = string<br>      to_port     = string<br>      cidr_block  = string<br>      rule_action = string<br>    })), [])<br>  })</pre> | <pre>{<br>  "inbound_acl_rules": [],<br>  "list": [],<br>  "outbound_acl_rules": []<br>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | <pre>object({<br>    list = list(string)<br>    inbound_acl_rules = optional(list(object({<br>      rule_number = string<br>      protocol    = string<br>      from_port   = string<br>      to_port     = string<br>      cidr_block  = string<br>      rule_action = string<br>    })), [])<br>    outbound_acl_rules = optional(list(object({<br>      rule_number = string<br>      protocol    = string<br>      from_port   = string<br>      to_port     = string<br>      cidr_block  = string<br>      rule_action = string<br>    })), [])<br>  })</pre> | <pre>{<br>  "inbound_acl_rules": [],<br>  "list": [],<br>  "outbound_acl_rules": []<br>}</pre> | no |
| <a name="input_vpc_azs"></a> [vpc\_azs](#input\_vpc\_azs) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | ID for the route table associated with the private subnets. |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private\_subnets\_ids) | List of private subnets within VPC. |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | ID for the route table associated with the public subnets. |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public\_subnets\_ids) | List of public subnets within the VPC. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC. |
<!-- END_TF_DOCS -->