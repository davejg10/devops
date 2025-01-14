#!/bin/bash

TERRAFORM_VERSION="1.10.4"
MVN_VERSION="3.9.9"
JDK_VERSION="21"

# Ensure each of /etc/profile.d/*.sh get called on each interactive shell
cat << 'EOF' >> ~/.bashrc
for file in /etc/profile.d/*.sh; do
    if [ -r "$file" ]; then
        source "$file"
    fi
done
EOF

echo "Installing Terraform version $TERRAFORM_VERSION"
chmod +x install_terraform.sh
./install_terraform.sh $TERRAFORM_VERSION

echo "Installing JDK version $JDK_VERSION"
chmod +x install_jdk.sh
./install_jdk.sh $JDK_VERSION

echo "Installing Maven version $MVN_VERSION"
chmod +x install_mvn.sh
./install_mvn.sh $MVN_VERSION

for file in /etc/profile.d/*.sh; do
    if [ -r "$file" ]; then
        source "$file"
    fi
done

echo PATH=$PATH >> /etc/ephemeral-github-actions-runner.env