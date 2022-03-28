# AWS Application Load Balancer with Terraform

## Step-01: Configure Profile for aws account credentials for programmatic access and update in provider.tf

```t
$ aws configure --profile {profile_name}
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```
Now Update in provider.tf,
```t
Configure the AWS Provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "%USERPROFILE%/.aws/credentials"
  profile                 = "terraformuser"
}
# Note: This is for windows config
```

## Step-02: Execute Terraform Commands
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

## Step-03: Access Application
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
## Step-04: Cleanup Terraform Application
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

