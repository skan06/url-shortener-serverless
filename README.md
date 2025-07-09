🚀 URL Shortener Serverless Project

This project implements a simple serverless URL shortener application deployed on AWS using Terraform as Infrastructure as Code (IaC). It demonstrates how to build scalable, cost-effective cloud-native applications with minimal operational overhead.

✨ Key Features
🧩 Serverless architecture using AWS Lambda for backend logic.
🌐 API Gateway HTTP API to expose RESTful endpoints for shortening URLs and redirection.
📦 DynamoDB table to store and retrieve short URL codes and their target URLs.
📊 CloudWatch Logs for monitoring Lambda executions.
🏠 S3 static website hosting for a minimal frontend interface allowing users to input URLs and receive shortened links.
🔐 IAM roles and policies configured securely to enable Lambda execution and resource access.
⚙️ Infrastructure fully managed and deployed with Terraform.
🏗️ Architecture Overview
📩 Users send POST requests to /shorten endpoint via API Gateway to shorten a URL.
🧪 Lambda function generates a unique 6-character code, stores it in DynamoDB, and returns the code.
🔗 Accessing /{code} redirects the user to the original URL stored in DynamoDB.
🖥️ The frontend website is hosted on S3 with static hosting enabled and a public-read bucket policy.
🛠️ Terraform handles all resource provisioning, permissions, and deployment automation.
🚀 Deployment

The infrastructure is deployed manually using Terraform CLI:

📦 Run zip lambda_function.zip lambda_function.py locally to package the Lambda code.
⚡ Use terraform init and terraform apply -auto-approve to create resources on AWS.
❌ No CI/CD automation such as GitHub Actions is used for deployment in this project.

📋 Prerequisites:

🔑 AWS account with appropriate permissions.
🛠️ Terraform installed locally.
🔧 AWS CLI configured with credentials.
🐍 Python 3.12 for Lambda runtime compatibility.