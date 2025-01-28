variable "aws_region" {
  description = "The AWS region to deploy the cluster"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
  default     = "my-k8s-cluster"
}

variable "master_instance_type" {
  description = "The instance type for the master node"
  type        = string
  default     = "t2.medium"
}

variable "node_instance_type" {
  description = "The instance type for the worker nodes"
  type        = string
  default     = "t2.medium"
}

variable "node_count" {
  description = "The number of worker nodes"
  type        = number
  default     = 3
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for the instances"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}