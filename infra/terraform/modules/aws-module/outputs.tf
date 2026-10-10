output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "Domain name of the s3 distribution"
}

locals {
  key_pair_id = try(
    tolist(aws_cloudfront_distribution.s3_distribution.trusted_key_groups[0].items[0].key_pair_ids)[0],
    null
  )
}

output "key-pair-id" {
  value       = local.key_pair_id
  description = "Key pair ids to use for accessing signed URL"
}