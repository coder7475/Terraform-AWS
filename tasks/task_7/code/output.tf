# Output Variables - Values returned after Terraform apply
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.first_bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.first_bucket.arn
}

output "environment" {
  description = "Environment from input variable"
  value       = var.environment
}

output "tags" {
  description = "Tags from local variable"
  value       = local.common_tags
}

output "vpc_arn" {
  description = "arn of vpc main"
  value = aws_vpc.main.arn
}

output "deployment_summary" {
  value       = "Environment: ${var.environment} | Instance Count: ${var.instance_count} | Name Tag: ${var.tags["Name"]}"
  description = "Summary of the deployment configuration"
}
