## Terraform Configuration

Terraform configuration is how you **describe your desired infrastructure in code** using HashiCorp Configuration Language (HCL). These configuration files tell Terraform what resources to create, how they relate to each other, and which providers to use.

### Core files

- **`main.tf`**: Main entry point where you usually define resources, data sources, and provider blocks.
- **`variables.tf`**: Input variables that allow you to parameterize your configuration.
- **`outputs.tf`**: Output values that expose important information (like IPs, URLs, IDs) after apply.
- **`providers.tf`** (optional but common): Provider configuration (e.g. AWS, Azure, GCP) and versions.

### Simple example

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t3.micro"
}
```

In this example:

- The **`terraform`** block defines which provider and version to use.
- The **`provider`** block configures how to connect (e.g. region).
- The **`resource`** block describes an actual piece of infrastructure Terraform will manage.

