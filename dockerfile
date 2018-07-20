FROM microsoft/vsts-agent:latest
                
ENV TERRAFORM_VERSION 0.11.7
ENV PACKER_VERSION 1.2.5
ENV ANSIBLE_VERSION 2.6.0

# Install Prerequisites
RUN echo "===> Installing Prerequisites" \
 && apt-get update \
 && apt-get install -y python-setuptools software-properties-common

# Install Packer
RUN echo "===> Installing Packer ${PACKER_VERSION} ..." \
 && wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
 && unzip packer_${PACKER_VERSION}_linux_amd64.zip  \
 && mv packer /usr/local/bin/packer \
 && rm packer_${PACKER_VERSION}_linux_amd64.zip 

# Install Terraform
RUN echo "===> Installing Terraform ${TERRAFORM_VERSION}..." \
 && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 &&	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && mv terraform /usr/local/bin/terraform \
 && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip 

 # Install Ansible
 RUN echo "===> Installing Ansible with the Azure Modules" \
  && sudo pip install --upgrade pip \
  && sudo pip install ansible[azure] \
  && ansible-galaxy install Azure.azure_preview_modules \
  && sudo pip install -r ~/.ansible/roles/Azure.azure_preview_modules/files/requirements-azure.txt \
  && sudo pip install azure-common==1.1.12

# Install PowerShell Core Extra Modules
SHELL [ "pwsh", "-command" ]
RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
RUN Install-Module -Name AzureRM.NetCore,Pester,PSScriptAnalyzer -Scope AllUsers