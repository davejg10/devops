#!/bin/sh

TERRAFORM_VERSION="1.10.4"
MVN_VERSION="3.9.9"
JDK_VERSION="21"

echo "Installing Terraform version $TERRAFORM_VERSION"
chmod +x install_terraform.sh
./install_terraform.sh $TERRAFORM_VERSION

echo "Installing Maven version $MVN_VERSION"
chmod +x install_mvn.sh
./install_mvn.sh $MVN_VERSION

echo "Installing JDK version $JDK_VERSION"
chmod +x install_jdk.sh
./install_jdk.sh $JDK_VERSION