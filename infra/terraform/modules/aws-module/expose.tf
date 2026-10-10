locals {
  static_origin_domain = aws_s3_bucket.storage["static"].bucket_regional_domain_name
  posts_origin_domain  = aws_s3_bucket.storage["posts"].bucket_regional_domain_name
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "Origin Access Identity for S3 buckets"
}

resource "aws_cloudfront_public_key" "access_key" {
  encoded_key = var.public_key_pem
  name        = "${var.environment}-access-key"
}

resource "aws_cloudfront_key_group" "access_key_group" {
  items = [aws_cloudfront_public_key.access_key.id]
  name  = "${var.environment}-access-key-group"
}

resource "aws_s3_bucket_policy" "update_bucket_policy" {
  for_each = local.buckets
  bucket   = aws_s3_bucket.storage[each.key].id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.default.id}"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.storage[each.key].arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = local.static_origin_domain
    origin_id   = local.static_origin_domain

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = local.posts_origin_domain
    origin_id   = local.posts_origin_domain

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.static_origin_domain
    cache_policy_id  = var.cache_policy_id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    trusted_key_groups = [aws_cloudfront_key_group.access_key_group.id]
  }

  ordered_cache_behavior {
    path_pattern     = "/posts/*" # This pattern will route requests to the posts bucket
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.posts_origin_domain
    cache_policy_id  = var.cache_policy_id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    trusted_key_groups = [aws_cloudfront_key_group.access_key_group.id]
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}