#!/bin/bash

macSetup()
{
    echo $USER - "Mac Setup"
    brew install awscli
    aws configure
    brew install kubernetes-cli
    kubectl version
    read -p "Install kops? [Y/n]" MAC_KOPS_CONFIG
    case $MAC_KOPS_CONFIG in
        [Yy]* ) macKopsSetup break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    read -p "Due you wish to use existing kube-configurations? [Y/n] " KUBE-CONFIG
    case $KUBE-CONFIG in
        [Yy]* ) configSetup break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    read -p "JenkinsX Setup? [Y/n] " MAC_JX_SETUP
    case $MAC_JX_SETUP in
        [Yy]* ) macJxSetup break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    
}

linuxSetup()
{
    echo $USER - "Linux Setup"
    sudo apt-get install -y awscli
    aws configure
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    kubectl version
    read -p "Install kops? [Y/n]" LINUX_KOPS_CONFIG
    case $LINUX_KOPS_CONFIG in
        [Yy]* ) linuxKopsSetup break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    read -p "Do you wish to use existing kube-configurations? [Y/n]" KUBE_CONFIG
    case $KUBE_CONFIG in
        [Yy]* ) configSetup break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    read -p "JenkinsX Setup? [Y/n] " LINUX_JX_SETUP
    case $LINUX_JX_SETUP in
        [Yy]* ) linuxJxSetup break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
}

linuxKopsSetup()
{
    wget https://github.com/kubernetes/kops/releases/download/1.10.0/kops-linux-amd64
    sudo chmod +x kops-linux-amd64
    sudo mv kops-linux-amd64 /usr/local/bin/kops
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
}

macKopsSetup()
{
    brew update && brew install kops
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
}

configSetup()
{
    echo "Where is that config file?"
    read -p "Local or Cloud (git) [L/c]" LC
    case $LC in
        [Ll]* ) localConfigSetup break;;
        [Cc]* ) gitConfigSetup break;;
        * ) echo "Please select correct option.";;
    esac
}

localConfigSetup()
{
    read -p "Please provide local config file path (Ex: /home/ubuntu/Data/config)" localConfigPath
    mkdir -p ~/.kube/
    cp -R $localConfigPath ~/.kube/
    echo "configured path - ~/.kube/"
    echo "listing files and directories..."
    ls ~/.kube/
}

gitConfigSetup()
{
    read -p "Please provide git repo url (Ex: https://hariomv-exzeo@bitbucket.org/exzeo-usa/harmony-web.git)" gitConfigPath
    mkdir -p ~/.kube/
    git clone gitConfigPath ~/.kube/
    echo "configured path - ~/.kube/"
    echo "listing files and directories..."
    ls ~/.kube/
    
}

macJxSetup()
{
    brew tap jenkins-x/jx
    brew install jx
}

linuxJxSetup()
{
    mkdir -p ~/.jx/bin
    curl -L https://github.com/jenkins-x/jx/releases/download/v2.0.137/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin
    export PATH=$PATH:~/.jx/bin
    echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc
}



# Ask the user for their os
echo welcome, $USER
echo what\'s your operating system?
echo 1. Mac
echo 2. Ubuntu
read os
if [[ $os == "1" || $os == "mac" ]]; then
    macSetup
    elif [[ $os == "2" || $os == "ubuntu" ]]; then
    linuxSetup
else
    echo wrong input!
    
fi

