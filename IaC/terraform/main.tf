terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "NardoClusterTf"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  cluster_addons = {
    #    coredns = {
    #      most_recent = true
    #    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-0cb3bfa4e20df9a0b"
  subnet_ids               = ["subnet-0852bbe71fdcaaa4d", "subnet-0e344b84222462d0e"]
  control_plane_subnet_ids = ["subnet-0852bbe71fdcaaa4d", "subnet-0e344b84222462d0e"]


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types             = ["t3.medium"]
    iam_role_attach_cni_policy = true

  }

  eks_managed_node_groups = {
    # Default node group - as provided by AWS EKS
    default_node_group = {
      # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
      # so we need to disable it to use the default template provided by the AWS EKS managed node group service
      use_custom_launch_template = false
      min_size     = 1
      max_size     = 2
      desired_size = 2
      disk_size = 8


    }
  }



  tags = {
    Terraform = "true"
  }
}