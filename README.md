# AWS Application Load Balancer with Terraform

## Steps to run the terraform files
- Create [AWS ALB Application Load Balancer Terraform Module](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest)

## Step-01: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

# Verify
Observation: 
1. Verify EC2 Instances
2. Verify Load Balancer SG
3. Verify ALB Listeners and Rules
4. Verify ALB Target Groups, Targets (should be healthy) and Health Check settings
5. Access sample app using Load Balancer DNS Name

## Step-02: Access Application
# Example:  To Access Application
```t
App-1
http://hr-stag-alb-1575108738.us-east-1.elb.amazonaws.com 
http://hr-stag-alb-1575108738.us-east-1.elb.amazonaws.com/app1/index.html
http://hr-stag-alb-1575108738.us-east-1.elb.amazonaws.com/app1/metadata.html
App-2
http://hr-stag-alb-1575108738.us-east-1.elb.amazonaws.com 
http://hr-stag-alb-1575108738.us-east-1.elb.amazonaws.com/app2/index.html
http://hr-stag-alb-1575108738.us-east-1.elb.amazonaws.com/app2/metadata.html
```

## Step-03: Cleanup Terraform Application
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

