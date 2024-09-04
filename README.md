# Medusa Backend Deployment on AWS ECS/Fargate

This project aims to design an Infrastructure as Code (IaC) setup using Terraform to deploy the Medusa open-source headless commerce platform backend on AWS ECS/Fargate, with continuous deployment (CD) managed through GitHub Actions.

## Project Overview

### Infrastructure Configuration

- **Terraform Configuration**:
  - Creates an ECR repository to store Docker images.
  - Sets up an ECS Cluster on AWS.
  - Defines a task definition for running your Docker container on Fargate.
  - Creates an ECS service to manage the task on Fargate.

- **GitHub Actions Configuration**:
  - Automates building and pushing the Docker image to ECR.

## Prerequisites

1. **AWS Account**: Ensure you have access to an AWS account with appropriate permissions to create ECR repositories, ECS clusters, and deploy services.
2. **GitHub Repository**: Have a GitHub repository with the following files:
   - `Dockerfile` (configured for Medusa backend).
   - `main.tf` (Terraform configuration file).
   - GitHub Actions workflow file (e.g., `.github/workflows/deploy.yml`).
3. **Secrets in GitHub**: Configure the following secrets in your GitHub repository:
   - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`: For AWS authentication.
   - `ECR_REPOSITORY_URI`: The URI of your ECR repository.

## Getting Started

### 1. Check for Dockerfile

Ensure that the `Dockerfile` is correctly configured to build the Medusa backend application. The Dockerfile should:
- Install necessary dependencies.
- Build the Medusa backend.
- Expose the correct port (e.g., 9000) for the application.

### 2. Set Up Secrets in GitHub

Go to your GitHub repository settings and set up the following secrets:
- **AWS_ACCESS_KEY_ID**: Your AWS access key.
- **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.
- **ECR_REPOSITORY_URI**: The URI of your ECR repository, which can be obtained from the AWS Management Console → ECR.

### 3. Ensure Correct ECR Configuration

- Make sure that the ECR repository name (e.g., `my-app-repo` in your Terraform file) matches the repository URI used in the GitHub Actions workflow.

### 4. Configure Subnets

- Replace `"subnet-xxxxxx"` in the ECS service definition within the Terraform file with your actual subnet ID(s) to ensure Fargate tasks can be deployed.

## Steps to Execute the Project

### 1. Push Your Code to GitHub

- Ensure your `Dockerfile`, `main.tf` (Terraform configuration), and GitHub Actions workflow file (e.g., `.github/workflows/deploy.yml`) are in your GitHub repository.
- Commit and push the changes to the `main` branch.

### 2. Verify GitHub Actions Workflow

Once the code is pushed, the GitHub Actions workflow should automatically trigger and execute the following steps:

1. **Checkout Code**: Pulls the latest code from the repository.
2. **Set Up Docker Buildx**: Prepares the environment for building Docker images.
3. **Log in to Amazon ECR**: Authenticates with AWS ECR to push the Docker image.
4. **Build and Push Docker Image**: Builds the Docker image using the provided Dockerfile and pushes it to the specified ECR repository.

### 3. Deploy with Terraform

- Ensure you have the Terraform CLI installed locally.
- Run the following commands in your terminal:

    ```bash
    terraform init     # Initialize Terraform and download the AWS provider
    terraform apply    # Apply the configuration to provision AWS resources
    ```

- Review the plan and confirm the changes.

### 4. Verify Deployment

- Check the AWS ECS console to ensure your cluster, task definition, and service are running correctly.
- Verify that the task is running on Fargate with the desired number of containers.

## Additional Considerations

- **Monitoring and Logging**: Consider setting up CloudWatch Logs to monitor your application's logs and metrics.
- **Scaling**: Adjust the `desired_count` and resource allocations (`cpu`, `memory`) in the Terraform file to match your application's needs.
- **Security**: Ensure that the AWS credentials are securely stored and rotate them periodically.

## Conclusion

By following these steps, you will successfully deploy the Medusa backend on AWS ECS/Fargate with a fully automated CD pipeline using GitHub Actions. This setup leverages Terraform for managing infrastructure as code, ensuring a consistent and repeatable deployment process.

# Happy Coding! and thanks to chatgpt for this (:
