<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.48 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.48 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_auth_configmap"></a> [aws\_auth\_configmap](#module\_aws\_auth\_configmap) | terraform-aws-modules/eks/aws//modules/aws-auth | ~> 20.8.5 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.8.5 |
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | ~> 2.2.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.eks_ecr_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_security_group_rule.metrics_server_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.app_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_auth_roles"></a> [aws\_auth\_roles](#input\_aws\_auth\_roles) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | n/a | `string` | `"1.29"` | no |
| <a name="input_control_plane_subnet_ids"></a> [control\_plane\_subnet\_ids](#input\_control\_plane\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_enabled_log_types"></a> [enabled\_log\_types](#input\_enabled\_log\_types) | n/a | `list(string)` | <pre>[<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_worker_managed_node_group_machine_types"></a> [worker\_managed\_node\_group\_machine\_types](#input\_worker\_managed\_node\_group\_machine\_types) | n/a | `list(string)` | <pre>[<br>  "t3.small",<br>  "t3.medium",<br>  "t3.large",<br>  "t3.xlarge",<br>  "t3.2xlarge"<br>]</pre> | no |
| <a name="input_worker_managed_node_group_max_size"></a> [worker\_managed\_node\_group\_max\_size](#input\_worker\_managed\_node\_group\_max\_size) | n/a | `number` | `10` | no |
| <a name="input_worker_managed_node_group_min_size"></a> [worker\_managed\_node\_group\_min\_size](#input\_worker\_managed\_node\_group\_min\_size) | n/a | `number` | `2` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->