# Terraform 

## EKS Cluster Creation

Using the main.tf file we create a 2 node cluster with a eks managed node group.

More documentation can be found here:

General example \
https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/19.15.3#input_aws_auth_roles

Example with eks managed node group with all parameters possible\
https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/eks_managed_node_group/main.tf

Various examples with eks and self managed groups \
https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/compute_resources.md#eks-managed-node-groups
https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest/submodules/eks-managed-node-group

```bash
# go 2 duh doe-rec-doe-ree
cd terraform

#initialize terraform to get all plugins for providers and more
terraform init

#format code to be pretty :)
terraform fmt

#validate that all arguments are correct
terraform validate

#validate resources to be created look right
terraform plan

#create resources, this can take a while, sometimes up to 15 minutes
terraform apply
```