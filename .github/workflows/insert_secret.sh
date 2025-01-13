#!/bin/bash
DEVOPS_KEY_VAULT_NAME=kv-glb-uks-devopsutils
GITHUB_APP_SECRET_NAME=somesecret

az keyvault update --name "$DEVOPS_KEY_VAULT_NAME" --public-network-access Enabled

echo "Verifying public access..."
while true; do
    PUBLIC_ACCESS=$(az keyvault show --name "$DEVOPS_KEY_VAULT_NAME" --query "properties.publicNetworkAccess" -o tsv)

    if [[ "$PUBLIC_ACCESS" == "Enabled" ]]; then
        echo "Key Vault is now public."
        break
    else
        echo "Key Vault is not yet public. Retrying in 5 seconds..."
        sleep 5
    fi
done

az keyvault secret set --vault-name "$DEVOPS_KEY_VAULT_NAME" --name "$GITHUB_APP_SECRET_NAME" --value "soemsecretdave"