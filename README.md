# End-to-End CI/CD on AWS EKS with Terraform & GitHub Actions

This project demonstrates a **production-style CI/CD pipeline** for deploying containerized applications on **Amazon EKS**, built using **Terraform (IaC)**, **GitHub Actions**, and **Kustomize**.  
It automates everything from infrastructure provisioning → container image build → Kubernetes deployment → ingress exposure.


## Features Implemented (Phase-1)

- Infrastructure provisioned with **Terraform**:
    
    - VPC, subnets, Internet Gateway, route tables.
        
    - Amazon **EKS cluster (1.30)** with managed node groups.
        
    - **Amazon ECR** repository for container images.
        
    - IAM OIDC & access entries for GitHub Actions deployment.
        
- CI/CD with **GitHub Actions**:
    
    - CI → Build & push Docker images to ECR.
        
    - CD → Deploy app to EKS using **Kustomize overlays**.
        
- Ingress Controller:
    
    - Installed **NGINX Ingress Controller** via Terraform Helm provider.
        
    - Service exposed through **AWS NLB** with public DNS.
        

## Workflow Overview

1. **Terraform Apply**
    
    - Creates EKS cluster, ECR repo, VPC, IAM roles.
        
    - Output: cluster name, region, ECR repo URL.
        
2. **GitHub Actions CI**
    
    - Builds Docker image.
        
    - Pushes to **Amazon ECR** with SHA + `latest` tags.
        
3. **GitHub Actions CD**
    
    - Authenticates to AWS using **OIDC** (no static keys).
        
    - Deploys app manifests using **Kustomize**.
        
    - Waits for rollout & verifies pod health.
        
4. **Ingress Exposure**
    
    - NGINX Ingress Controller provisioned via Helm.
        
    - LoadBalancer DNS created in AWS → accessible endpoint.
        

## How to Run

### Prerequisites

- Terraform `>= 1.5`
    
- AWS CLI configured
    
- kubectl + kustomize installed
    
- GitHub repo with Actions enabled
    

### Steps

1. Clone the repo & init Terraform:
    
    `cd terraform terraform init terraform apply`
    
2. Push code to `main` branch → triggers GitHub Actions:
    
    - CI builds image → pushes to ECR.
        
    - CD applies manifests to EKS.
        
3. Verify deployment:
    
    `kubectl get pods -n demo kubectl get svc -n ingress-nginx ingress-nginx-controller`
    
    Copy the **NLB DNS** to access the app.
    