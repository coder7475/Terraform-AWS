# Day 18 - AWS Lambda with Terraform
## Step-by-Step Beginner Guide

This guide walks you through creating a serverless image processor from scratch using AWS Lambda and Terraform.

---

## What We're Building

We'll create an automated image processing pipeline:
1. You upload an image to an S3 bucket
2. Lambda automatically triggers
3. Lambda creates 5 processed versions (compressed, low-quality, WebP, PNG, thumbnail)
4. All variants are saved to another S3 bucket

---

## Prerequisites

- AWS Account (free tier works)
- Terraform installed locally
- AWS CLI configured with credentials
- A test image file

---

## Step 1: Create Project Directory

```bash
mkdir -p day18-terraform-lambda/{terraform,lambda}
cd day18-terraform-lambda
```

---

## Step 2: Create the Provider Configuration

Create `terraform/provider.tf`:

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

---

## Step 3: Define Variables

Create `terraform/variables.tf`:

```hcl
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "image-processor"
}
```

---

## Step 4: Create the Lambda Function (Python)

Create `lambda/lambda_function.py`:

```python
import boto3
import io
from PIL import Image
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Get bucket name from environment
    processed_bucket = os.environ.get('PROCESSED_BUCKET')
    
    # Get bucket and key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    print(f"Processing {key} from {bucket}")
    
    # Download the image from S3
    response = s3.get_object(Bucket=bucket, Key=key)
    image_data = response['Body'].read()
    
    # Open image using Pillow
    image = Image.open(io.BytesIO(image_data))
    
    # Get base name (without extension)
    base_name = key.rsplit('.', 1)[0]
    
    # Create output buffer for each variant
    variants = {}
    
    # 1. Compressed JPEG (85% quality)
    output = io.BytesIO()
    image.convert('RGB').save(output, format='JPEG', quality=85)
    output.seek(0)
    variants[f"{base_name}_compressed.jpg"] = output
    
    # 2. Low quality JPEG (60% quality)
    output = io.BytesIO()
    image.convert('RGB').save(output, format='JPEG', quality=60)
    output.seek(0)
    variants[f"{base_name}_low.jpg"] = output
    
    # 3. WebP format
    output = io.BytesIO()
    image.convert('RGB').save(output, format='WEBP', quality=85)
    output.seek(0)
    variants[f"{base_name}.webp"] = output
    
    # 4. PNG format
    output = io.BytesIO()
    image.convert('RGB').save(output, format='PNG')
    output.seek(0)
    variants[f"{base_name}.png"] = output
    
    # 5. Thumbnail (200x200)
    thumbnail = image.copy()
    thumbnail.thumbnail((200, 200))
    output = io.BytesIO()
    thumbnail.convert('RGB').save(output, format='JPEG', quality=80)
    output.seek(0)
    variants[f"{base_name}_thumbnail.jpg"] = output
    
    # Upload all variants to processed bucket
    for file_name, file_data in variants.items():
        s3.upload_fileobj(
            file_data,
            processed_bucket,
            file_name,
            ExtraArgs={'ContentType': 'image/jpeg' if '.jpg' in file_name else 'image/webp' if '.webp' in file_name else 'image/png'}
        )
        print(f"Uploaded: {file_name}")
    
    return {
        'statusCode': 200,
        'body': f'Processed {key} into 5 variants'
    }
```

---

## Step 5: Create the Main Terraform Configuration

Create `terraform/main.tf`. We'll build this step by step.

### Part 5a: Setup Variables and Locals

```hcl
# Random suffix for unique bucket names
resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_prefix         = "${var.project_name}-${var.environment}"
  upload_bucket_name    = "${local.bucket_prefix}-upload-${random_id.suffix.hex}"
  processed_bucket_name = "${local.bucket_prefix}-processed-${random_id.suffix.hex}"
  lambda_function_name  = "${var.project_name}-${var.environment}-processor"
}
```

### Part 5b: Create S3 Buckets

```hcl
# Upload Bucket (source)
resource "aws_s3_bucket" "upload_bucket" {
  bucket = local.upload_bucket_name
}

# Enable versioning
resource "aws_s3_bucket_versioning" "upload_bucket" {
  bucket = aws_s3_bucket.upload_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "upload_bucket" {
  bucket = aws_s3_bucket.upload_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "upload_bucket" {
  bucket = aws_s3_bucket.upload_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Processed Bucket (destination) - same pattern
resource "aws_s3_bucket" "processed_bucket" {
  bucket = local.processed_bucket_name
}

resource "aws_s3_bucket_versioning" "processed_bucket" {
  bucket = aws_s3_bucket.processed_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "processed_bucket" {
  bucket = aws_s3_bucket.processed_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "processed_bucket" {
  bucket = aws_s3_bucket.processed_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### Part 5c: Create IAM Role for Lambda

```hcl
# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${local.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.lambda_function_name}-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # CloudWatch Logs permissions
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:us-east-1:*:*"
      },
      # Read from upload bucket
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "${aws_s3_bucket.upload_bucket.arn}/*"
      },
      # Write to processed bucket
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.processed_bucket.arn}/*"
      }
    ]
  })
}
```

### Part 5d: Create Lambda Function

```hcl
# Package the Lambda function as a ZIP
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda Function
resource "aws_lambda_function" "image_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = local.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.12"
  timeout          = 60
  memory_size      = 1024

  environment {
    variables = {
      PROCESSED_BUCKET = aws_s3_bucket.processed_bucket.id
      LOG_LEVEL        = "INFO"
    }
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_processor" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 7
}
```

### Part 5e: Configure S3 Trigger

```hcl
# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.upload_bucket.arn
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "upload_bucket_notification" {
  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
```

---

## Step 6: Create Outputs

Create `terraform/outputs.tf`:

```hcl
output "upload_bucket_name" {
  description = "Name of the upload S3 bucket"
  value       = aws_s3_bucket.upload_bucket.id
}

output "processed_bucket_name" {
  description = "Name of the processed S3 bucket"
  value       = aws_s3_bucket.processed_bucket.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.image_processor.function_name
}

output "upload_command_example" {
  description = "Example command to upload an image"
  value       = "aws s3 cp your-image.jpg s3://${aws_s3_bucket.upload_bucket.id}/"
}
```

---

## Step 7: Deploy

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan what will be created
terraform plan

# Apply the changes
terraform apply

# Note the bucket names from output
```

---

## Step 8: Test It

```bash
# Upload a test image
terraform output upload_command_example
# Copy the command and replace "your-image.jpg" with your image

aws s3 cp my-photo.jpg s3://image-processor-dev-upload-abc123/

# Wait a few seconds, then check processed bucket
aws s3 ls s3://image-processor-dev-processed-abc123/
```

You should see 5 files:
- my-photo_compressed.jpg
- my-photo_low.jpg
- my-photo.webp
- my-photo.png
- my-photo_thumbnail.jpg

---

## Step 9: View Logs

```bash
# Watch Lambda logs
aws logs tail /aws/lambda/image-processor-dev-processor --follow
```

---

## Step 10: Cleanup

```bash
# Destroy all resources
terraform destroy
```

---

## Summary

You built:
1. **2 S3 Buckets** - One for upload, one for processed images
2. **IAM Role & Policy** - Gives Lambda permissions to read/write S3
3. **Lambda Function** - Python code that processes images
4. **S3 Trigger** - Automatically runs Lambda when image is uploaded

This is a serverless architecture - no servers to manage, scales automatically!

