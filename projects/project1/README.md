This plan outlines the first project in your Terraform learning journey, focusing on deploying a serverless MVP with local state management. As of January 2026, these steps follow current best practices for getting started with Infrastructure as Code (IaC). [youtube](https://www.youtube.com/watch?v=Bzccj0jjRBM)

### Project Overview
The goal is to deploy a simple serverless backend using AWS Lambda and API Gateway, with a static S3 bucket for hosting. This project introduces you to the core Terraform workflow: defining resources, checking execution plans, and applying changes to your cloud environment. [developer.hashicorp](https://developer.hashicorp.com/terraform/tutorials/cli/plan)

### Setup and Authentication
Before writing code, you must configure your local environment to communicate with AWS securely.
- **Install Tools**: Ensure you have the AWS CLI v2 and Terraform installed and verified in your terminal. [dev](https://dev.to/aws-builders/deploying-amazon-api-gateway-and-lambda-with-terraform-1i2o)
- **Authenticate**: Use `aws configure` to set your Access Key ID and Secret Access Key, or export them as environment variables (e.g., `AWS_ACCESS_KEY_ID`) to allow Terraform to authenticate with your account. [dev](https://dev.to/pavithra_sandamini/exploring-different-ways-to-authenticate-terraform-cli-with-aws-566l)
- **Provider Config**: Create a `provider.tf` file to specify the AWS provider and your target region (e.g., `us-east-1`). [dev](https://dev.to/pavithra_sandamini/exploring-different-ways-to-authenticate-terraform-cli-with-aws-566l)

### Core Infrastructure Components
You will define three primary resources in your `main.tf` file to build the application stack.
- **Static Hosting**: Use the `aws_s3_bucket` resource to create a bucket for your React or frontend files. [developer.hashicorp](https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway)
- **Serverless Logic**: Define an `aws_lambda_function` to run your backend code without managing servers. [projectpro](https://www.projectpro.io/article/terraform-projects-examples/621)
- **API Entry Point**: Set up `aws_apigatewayv2_api` to create an HTTP endpoint that triggers your Lambda function. [developer.hashicorp](https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway)

### Terraform Execution Workflow
The project follows a standard four-step lifecycle to manage your infrastructure state locally. [linkedin](https://www.linkedin.com/posts/keshav-agarwal-2522831a2_one-of-the-most-important-and-sometimes-activity-7391123477056937984-VnTa)

| Command | Action | Purpose |
| :--- | :--- | :--- |
| `terraform init` | Initialize | Downloads the AWS provider plugins and prepares the working directory  [pass4sure](https://www.pass4sure.com/blog/managing-terraform-state-understanding-local-and-remote-state-management/). |
| `terraform plan` | Preview | Shows a "diff" of what Terraform will create, change, or delete without making actual changes  [developer.hashicorp](https://developer.hashicorp.com/terraform/tutorials/cli/plan). |
| `terraform apply` | Deploy | Executes the plan to create your S3 bucket, Lambda, and API Gateway in AWS  [developer.hashicorp](https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway). |
| `terraform destroy` | Cleanup | Safely removes all resources created by this project to avoid unnecessary AWS costs  [youtube](https://www.youtube.com/watch?v=Bzccj0jjRBM). |

### Managing Local State
In this first project, Terraform creates a `terraform.tfstate` file in your local directory. This file is the "source of truth" that maps your code to real AWS resources. You should never manually edit this file or commit it to version control; instead, rely on Terraform commands to update it as your infrastructure evolves. [developer.hashicorp](https://developer.hashicorp.com/terraform/language/state)
