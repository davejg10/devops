#!/bin/bash

TASK_NAME="build_and_push_custom_image"
system_identity_principal=$(az acr task create -n $TASK_NAME -r ${azurerm_container_registry.devops.name} -c /dev/null -f acb.yaml --auth-mode None --assign-identity [system] --base-image-trigger-enabled false --query "identity.principalId" -o tsv)
az role assignment create --role AcrPush --assignee-object-id $system_identity_principal --assignee-principal-type ServicePrincipal --scope ${azurerm_container_registry.devops.id}
az acr task credential add -r ${azurerm_container_registry.devops.name} -n $TASK_NAME --login-server ${azurerm_container_registry.devops.login_server} --use-identity [system]