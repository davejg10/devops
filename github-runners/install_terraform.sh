#!/bin/bash

# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1

terraform -version
if [ "$(terraform version -json | grep terraform_version  | awk -F'\"' '{print $4}')" == "$VERSION" ]; then
  echo "[INFO] terraform $VERSION already installed, skipping installation"
else
  echo "[INFO] terraform $VERSION version not found. Downloading and installing terraform"
  wget "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip" -O terraform.zip
  sudo unzip -o "terraform.zip" -d /usr/local/bin
  rm terraform.zip
  terraform --version
fi