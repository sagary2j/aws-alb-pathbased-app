variable "prefix" {
  default = "devapp"
}

variable "region" {
  default = "us-east-1"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zone" {
  description = "availability zone to create subnet"
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_key_path" {
  description = "Public key path"
  default     = "C:/Users/sagar/.ssh/id_rsa.pub"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default     = "t2.micro"
}
variable "environment" {
  description = "Environment tag"
  default     = "dev"
}

variable "user_data_file" {
  description = "Environment tag"
  type        = list(any)
  default     = ["./app1_install.sh", "./app2_install.sh"]
}