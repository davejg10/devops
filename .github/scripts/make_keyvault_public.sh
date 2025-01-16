#!/bin/bash
KEY_VAULT=$1

# Insert the secret into the Key Vault
az keyvault update --name "$KEY_VAULT" --public-network-access Enabled

echo "Verifying public access..."
while true; do
    PUBLIC_ACCESS=$(az keyvault show --name "$KEY_VAULT" --query "properties.publicNetworkAccess" -o tsv)

    if [[ "$PUBLIC_ACCESS" == "Enabled" ]]; then
        echo "Key Vault is now public."
        break
    else
        echo "Key Vault is not yet public. Retrying in 5 seconds..."
        sleep 5
    fi
done