#!/bin/bash
ENV=$1

echo "Terraform plan: $ENV"
terraform init -reconfigure -backend-config="key=nomad-01-$ENV.tfstate"
terraform plan --var-file="./tfvars/$ENV.tfvars" -out tfplan-$ENV.tfplan