#!/bin/bash
KEY_VAULT=$1

echo "Changing network access of $KEY_VAULT to private"
az keyvault update --name "$KEY_VAULT" --public-network-access Disabled