#!/bin/bash
ENV=$1

echo "Terraform apply: $ENV"
terraform apply tfplan-$ENV.tfplan

rm tfplan-$ENV.tfplan