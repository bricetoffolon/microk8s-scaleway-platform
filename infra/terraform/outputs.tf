output "instance_public_ip" {
  value       = module.scaleway_instance.instance_public_ip
  description = "Public IP of the MicroK8s node (consumed by the Ansible job)."
  sensitive   = true
}

output "cloudfront_domain_name" {
  value       = one(module.aws_storage[*].distribution_domain_name)
  description = "CloudFront domain, null when storage is disabled."
}
