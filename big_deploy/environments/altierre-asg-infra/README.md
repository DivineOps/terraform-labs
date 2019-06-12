# Altierre-ASG

The `altierre-asg-infra` environment is a non-production ready template we provide to easily deploy the Altierre ASG Infrastructure Environment  on Azure.

## Getting Started

1. git clone the entire directory
2. cd to the terraform directory
3. create a new directory called deployments
4. create a new directory for the specific deployment you will create
5. Copy the `main.tf`, `variables.tf` and `terraform.tfvars` files from the `./altierre/terraform/environments/altierre-asg-infra` directory to the new directory you created under deployments.
6. Run `terraform init` and `terraform plan` from the `./altierre/terraform/deployments/<deploymentname> directory`