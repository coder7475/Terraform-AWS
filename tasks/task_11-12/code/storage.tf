# Simple S3 Bucket
resource "aws_s3_bucket" "merge_bucket" {
  bucket = local.formatted_bucketname

  tags = local.tags
}
