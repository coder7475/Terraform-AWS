# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform with AWS video course repository containing code samples and documentation for each video lesson. It covers basic to advanced Terraform concepts with hands-on projects and real-world AWS scenarios.

## Code Architecture

The repository is organized into:
- `lessons/dayXX/` - Code samples organized by day/topic
- `aws/` - AWS-specific examples (Lambda, API Gateway)
- `projects/` - Complete project implementations
- `tasks/` - Practice tasks with README files

Each lesson folder typically contains:
- `code/` - Working Terraform code
- `task.md` - Exercise instructions
- `README.md` - Topic explanation

## Common Commands

```bash
# Initialize Terraform
terraform init

# Validate syntax
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Format code
terraform fmt

# Show outputs
terraform output
```

## Key Patterns

- Lessons use AWS as the cloud provider
- Each lesson builds on previous concepts (follows sequential learning path)
- Day 20+ contains real-time projects with EKS, RDS, and 3-tier architectures
- Some lessons have custom modules in `lessons/20/code/`
- Frontend code in `lessons/day28/frontend/` uses Node.js with npm

## Testing Infrastructure

GitHub Actions workflows handle:
- `create-participant.yml` - Creating participant resources
- `drift_detection.yml` - Detecting infrastructure drift
- `tf-destroy.yml` - Tearing down test infrastructure

## Important Notes

- State files and `.tfvars` are gitignored
- Day 25 covers Terraform import (migrating existing AWS resources)
- Day 27 covers CI/CD with Terraform Cloud
- Some lessons use remote backends for state management
- Lessons 28-31 cover advanced topics (3-tier architecture, GitOps, drift detection)

