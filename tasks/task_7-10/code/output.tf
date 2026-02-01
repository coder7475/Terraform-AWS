# Output Variables - Values returned after Terraform apply
# output "bucket_name" {
#   description = "Name of the S3 bucket"
#   value       = aws_s3_bucket.first_bucket.bucket
# }

# output "bucket_arn" {
#   description = "ARN of the S3 bucket"
#   value       = aws_s3_bucket.first_bucket.arn
# }

output "environment" {
  description = "Environment from input variable"
  value       = var.environment
}

output "tags" {
  description = "Tags from local variable"
  value       = local.common_tags
}

# output "vpc_arn" {
#   description = "arn of vpc main"
#   value = aws_vpc.main.arn
# }

# output "deployment_summary" {
#   value       = "Environment: ${var.environment} | Instance Count: ${var.instance_count} | Name Tag: ${var.tags["Name"]}"
#   description = "Summary of the deployment configuration"
# }

output "dynamic_sg_id" {
  description = "Security group ID with dynamic rules"
  value       = aws_security_group.web_sg.id
}

output "security_group_rules_count" {
  description = "Number of ingress rules created dynamically"
  value       = length(var.ingress_rules)
}

# ==============================================================================
# EXAMPLE 3 OUTPUTS: SPLAT EXPRESSION
# ==============================================================================
# Uncomment when testing Example 3

output "all_instance_ids" {
  description = "All instance IDs using splat expression [*]"
  value       = aws_instance.my_instance[*].id
}

output "all_private_ips" {
  description = "All private IPs using splat expression [*]"
  value       = aws_instance.my_instance[*].private_ip
}
