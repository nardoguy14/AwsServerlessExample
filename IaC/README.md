# Halyard

Used to create a spinnaker instance on EKS Kubernetes.

To run execute the following:

```shell
cd IaC/cicd/halyard
docker build -f DockerfileHalyard -t customized-halyard  \
--build-arg AWS_KEY_ID=<REPLACEME> \
--build-arg AWS_SECRET_KEY=<REPLACEME> \
--build-arg REGION=<REPLACEME> \
--build-arg CLUSTER_NAME=<REPLACEME> \
--build-arg S3_BUCKET=<REPLACEME> .
```

Afterwards you may run the container via:

```shell
docker run -it --name my-halyard customized-halyard
```

To add images for Spinnaker to pull from this must be ran with halyard
```shell
hal config provider docker-registry account \
add my-ecr-registry2  \
--address public.ecr.aws  \
--repositories z3r6l3x6/fairpricepokeapi
```

# Cicd Pipeline

To create a CICD pipeline we rely on multiple pieces. The first portion detects changes
in source code within a github respository and builds an image for kubernetes that it then pushes
to AWS ECR to be pulled from. Codepipeline is used alongside Codebuild to create the part that 
pulls the new source code revision, builds an image, and pushes it to ECR. The next bit is
syncing Kubernetes to apply the new image. This is done by means of FluxCD. We can define a kustomization and source
for FluxCD to pull new source code from as well as apply new Kubernetes manifests defined in 
`resources/kubernetes/fuxCD/kustomize`. The following repo can be visited to see the definitions
for the fluxCD deployment: https://github.com/nardoguy14/fleet-infra.

## Cloudformation

Cloudformation code is used to create the CodePipeline that runs the CodeBuild project for both
Kubernetes Image building and sam package building for a serverless Lambda function.

Two seperate files exist one that houses the pipeline for serverless building and 
another that handles the pipeline for kubernetes image building.

To execute these we need to perform the following

```bash
cd IaC/cicd/cloudformation

aws cloudformation create-stack \
  --stack-name testpipelinestack \
  --template-body file://codepipeline_kubernetes_eks_project.yaml \
  --region us-east-1

```

# Infrastructure Resources

Terraform and eskctl are used to create a EKS Kubernetes cluster for means of using to deploy
this application. We present two methods of creating these resources 1 via terraform and 2 via
eksctl.

## Terraform 

### EKS Cluster Creation

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

## Eskctl

An easier method for creating a kubernetes cluster via eskctl with a yaml file.

More documentation can be found here:

Config files for cluster creation \
https://eksctl.io/usage/creating-and-managing-clusters/
