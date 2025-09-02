
# Scalable WebApp Infrastructure

This project uses **Terraform** to deploy a highly available and scalable web application infrastructure on **AWS**. The infrastructure includes:  

- VPC with public and private subnets  
- Internet Gateway and NAT Gateways  
- Route tables and associations  
- Security groups  
- EC2 instances (with launch template)  
- Application Load Balancer (ALB)  
- RDS database  
- IAM roles and instance profiles  

---

## **Prerequisites**

1. **Terraform** installed (v1.5.0 or later recommended)  
   [Install Terraform](https://developer.hashicorp.com/terraform/downloads)  

2. **AWS CLI** configured with credentials  
   ```bash
   aws configure
   ```  

3. AWS account with permissions to create:  
   - VPC, Subnets, NAT Gateway, IGW  
   - EC2, ALB, RDS  
   - IAM roles, policies  
   - S3 bucket and DynamoDB table (for Terraform backend)

---

## **Project Structure**

```
.
├── main.tf          # Core infrastructure resources
├── variables.tf     # Input variables
├── output.tf        # Terraform outputs
├── terraform.tfvars # Optional: Values for variables
├── README.md        # This file
└── modules/         # Optional: Separate modules
```

---

## **Deployment Instructions**

### 1. Initialize Terraform
Initialize the backend and download provider plugins:
```bash
terraform init
```

> If backend config changes, use:
```bash
terraform init -reconfigure
```

### 2. Review Execution Plan
Check what Terraform will create/update:
```bash
terraform plan
```

### 3. Apply the Terraform Configuration
Deploy the infrastructure:
```bash
terraform apply
```

Type `yes` when prompted.

### 4. Verify Outputs
After a successful apply, view important resource IDs and endpoints:
```bash
terraform output
```

This will display VPC ID, subnets, NAT Gateway IDs, Internet Gateway, etc.

### 5. Destroy Infrastructure (Optional)
To clean up resources:
```bash
terraform destroy
```

---

## **Variables**

Example `terraform.tfvars`:

```hcl
region = "ap-south-1"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
```

You can change these values according to your requirements.

---

## **Notes**

- Make sure the **S3 bucket** and **DynamoDB table** exist before running Terraform if using remote state.  
- NAT Gateway creation may take 2–3 minutes.  
- ALB and EC2 instance deployment requires proper IAM permissions.  
