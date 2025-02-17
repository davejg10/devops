#!/bin/bash

ENV=$1

NOMAD_RG_NAME="rg-$ENV-uks-nomad-01"

# az webapp delete --name "web-t-$ENV-uks-nomad-01" --resource-group $NOMAD_RG_NAME

# az appservice plan delete --name "asp-$ENV-uks-nomad-01" --resource-group $NOMAD_RG_NAME -y

# az vm stop --name "vm-$ENV-uks-nomad-neo4j-01" --resource-group $NOMAD_RG_NAME

# az vm deallocate --name "vm-$ENV-uks-nomad-neo4j-01" --resource-group $NOMAD_RG_NAME

GH_RUNNERS_RG_NAME="rg-glb-uks-ghrunners"

az containerapp job show --name "aca-glb-uks-nomad-infra" --resource-group "rg-glb-uks-ghrunners"

az containerapp job update --name "aca-glb-uks-nomad-infra" --resource-group "rg-glb-uks-ghrunners" --min-executions 0 --scale-rule-name "github-runner-scaling-rule" --scale-rule-type "github-runner" --scale-rule-metadata ""