FROM myoung34/github-runner:ubuntu-jammy

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

COPY install_script.sh install_script.sh
COPY install_terraform.sh install_terraform.sh
COPY install_mvn.sh install_mvn.sh
COPY install_jdk.sh install_jdk.sh

SHELL ["/bin/bash", "-c"]

RUN chmod +x install_script.sh
RUN ./install_script.sh
