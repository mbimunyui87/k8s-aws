output "master_public_ip" {
  description = "The public IP address of the master node"
  value       = aws_instance.k8s_master.public_ip
}

output "node_private_ips" {
  description = "The private IP addresses of the worker nodes"
  value       = aws_instance.k8s_node[*].private_ip
}

output "cluster_name" {
  description = "The name of the Kubernetes cluster"
  value       = var.cluster_name
}