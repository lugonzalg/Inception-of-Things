#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "---------------------------------------------"
echo "| Setting up the Inception-Of-Things project|"
echo "---------------------------------------------"
echo ""

check_retval() {

    case $1 in

    Yy)
        return 1;;
    Nn)
        return 0;;
    *)
        return 0;;
    esac
}

install_package() {

    package=$1

    which $package
    if [ $? -ne 0 ]; then

        echo -e "${RED}$package ${NC}not found!"

        echo -e -n "Do you want to install $package? [${GREEN}Yy${NC}/${RED}Nn${NC}]: "
        read retval

        check_retval $retval

        if [ $? -eq 1 ]; then
            echo -e "Installing ${GREEN}$package${NC} into the server!"
            sudo apt install $package -y
        fi

    else
        echo "$package found!"
    fi

}

install_k3s() {
    curl -sfL https://get.k3s.io | sh -
    sudo kubectl get nodes
}

install_kubectl () {
    ls /usr/local/bin/kubectl

    if [ $? ]; then

        echo -e "Missing ${RED}/usr/local/bin/kubectl${NC}"

        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
        echo "$(cat kubectl.sha256) kubectl" | sha256sum --check

        retval=$?
        if [ $retval -eq 0 ]; then
            echo "Assign kubectl to /usr/local/bin/kuberctl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        fi

    else
        echo "${GREEN}/usr/local/bin/kubectl${NC} is alreaedy installed!"
    fi

}

install_package virtualbox
install_package vagrant
install_kubectl
install_k3s