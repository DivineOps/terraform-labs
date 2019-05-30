# Showcase

- Azure
- AKS
- Terraform
- Helm
- Let's Encrypt

# Quickstart

```sh
# clone example repository
git clone https://github.com/core-process/aks-terraform-helm.git
cd ./aks-terraform-helm

# login to Azure and set subscription
az login
az account set --subscription <ID>

# prepare infrastructure configuration
cp ./infrastructure/terraform.tfvars.template ./infrastructure/terraform.tfvars
code ./infrastructure/terraform.tfvars


# deploy infrastructure

cd ./infrastructure
terraform init
terraform apply

# export variables for app deployment

# ... will be used by docker compose
export IMAGE_REGISTRY="$(terraform output CR_ENDPOINT)"
export IMAGE_LABEL="latest"

# ... will be used later (see open command in last line)
export APP_URL="https://$(terraform output K8S_INGRESS_FQDN)"


# deploy app
cd ..
helm upgrade --debug --install --wait -f ./app.values.yaml --set ImageLabel=$IMAGE_LABEL example ./chart

# inspect deployed resources
helm status example
kubectl get deployments
kubectl get pods
kubectl get services


