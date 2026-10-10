variable "environment" {
  type        = string
  description = "Deployment environment."

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment must be one of: dev, staging, production."
  }
}

variable "domain_name" {
  type        = string
  description = "Apex domain managed in Cloudflare."
  default     = "example.com"
}

variable "company_name" {
  type        = string
  description = "Prefix used to name AWS resources (S3 buckets)."
  default     = "example"
}

variable "project_id" {
  type        = string
  description = "Scaleway project ID."
}

variable "instance_type" {
  type        = string
  description = "Scaleway instance type."
  default     = "DEV1-M"
}

variable "ssh_key" {
  type        = string
  description = "Public SSH key injected into the instance for the ansible user."
  sensitive   = true
}

variable "scaleway_ansible_user" {
  type        = string
  description = "Username of the ansible user created by cloud-init."
  sensitive   = true
}

variable "admin_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach SSH (22) and the Kubernetes API (16443). Restrict this outside of demos."
  default     = ["0.0.0.0/0"]
}

variable "enable_storage" {
  type        = bool
  description = "Create the S3 buckets and CloudFront distribution."
  default     = true
}

variable "cloudfront_public_key_pem" {
  type        = string
  description = "PEM public key used to verify CloudFront signed URLs. Required when enable_storage is true."
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region."
  default     = "eu-west-3"
}

variable "scaleway_zone" {
  type        = string
  description = "Scaleway zone."
  default     = "fr-par-1"
}

variable "scaleway_region" {
  type        = string
  description = "Scaleway region."
  default     = "fr-par"
}
