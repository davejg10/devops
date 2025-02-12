#!/bin/bash
ENV=$1

echo "Terraform plan: $ENV"
terraform init -reconfigure -backend-config="key=backup-$ENV.tfstate"
terraform plan --var-file="./tfvars/$ENV.tfvars" -out tfplan-$ENV.tfplan