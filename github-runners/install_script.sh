#!/bin/bash

TERRAFORM_VERSION="1.10.4"
MVN_VERSION="3.9.9"
JDK_VERSION="21"

cat << 'EOF' >> ~/.bashrc
for file in /etc/profile.d/*.sh; do
    if [ -r "$file" ]; then
        . "$file"
    fi
done
EOF

echo

echo "the shell iS"
ps -p $$ -o comm=

echo
cat ~/.bashrc

echo "Installing Terraform version $TERRAFORM_VERSION"
chmod +x install_terraform.sh
./install_terraform.sh $TERRAFORM_VERSION

echo "Installing JDK version $JDK_VERSION"
chmod +x install_jdk.sh
./install_jdk.sh $JDK_VERSION

source ~/.bashrc
echo "Installing Maven version $MVN_VERSION"
chmod +x install_mvn.sh
./install_mvn.sh $MVN_VERSION

source ~/.bashrc