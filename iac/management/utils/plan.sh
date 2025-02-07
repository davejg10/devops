#!/bin/bash

echo "Terraform plan"
terraform init -reconfigure
terraform plan -out tfplan.tfplan