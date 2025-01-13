FROM myoung34/github-runner:ubuntu-jammy

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# install Terraform
COPY install_terraform.sh install_terraform.sh
RUN chmod +x install_terraform.sh

RUN ./install_terraform.sh 1.10.4