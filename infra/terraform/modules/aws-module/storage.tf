locals {
  buckets = toset(["static", "posts"])
}

resource "aws_s3_bucket" "storage" {
  for_each = local.buckets
  bucket   = "${var.environment}-${var.company_name}-${each.key}"

  tags = {
    Environment = var.environment
  }
}

# To comply with the cloudfront policy to reach content from /posts/ for posts bucket
resource "aws_s3_object" "posts_folder" {
  bucket       = aws_s3_bucket.storage["posts"].id
  key          = "posts/"
  content_type = "application/x-directory"
}
