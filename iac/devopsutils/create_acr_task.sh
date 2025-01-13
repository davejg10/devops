#!/bin/bash

TASK_NAME="build_and_push_image"
system_identity_principal=$(az acr task create -n $TASK_NAME -r $ACR_NAME -c /dev/null -f acb.yaml --auth-mode None --assign-identity [system] --base-image-trigger-enabled false --query "identity.principalId" -o tsv)
az role assignment create --role AcrPush --assignee-object-id $system_identity_principal --assignee-principal-type ServicePrincipal --scope  $ACR_ID
az acr task credential add -r  $ACR_NAME -n $TASK_NAME --login-server  $ACR_LOGIN_SERVER --use-identity [system]