#!/bin/bash

distro=$(lsb_release -is)
user=$(whoami)

function setupDockerDebian() {
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    usermod -aG docker $user
}

function setupDockerUbuntu() {
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    usermod -aG docker $user
}

function setupDockerCentOS() {
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
    systemctl enable docker
    systemctl start docker
}

function setupDockerFedora() {
    dnf install -y dnf-plugins-core
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y docker-ce
    systemctl enable docker
    systemctl start docker
}

function setupDockerRHEL() {
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
    systemctl enable docker
    systemctl start docker
}

function setupDockerSLES() {
    zypper addrepo -f -g -t YUM https://download.docker.com/linux/suse/x86_64/docker-ce.repo
    zypper --gpg-auto-import-keys refresh
    zypper install -y docker-ce
    systemctl enable docker
    systemctl start docker
}

function setupDockerCompose() {
    curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

function main(){
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or sudo"
        exit
    fi
    if [ "$distro" == "Debian" ]; then
        setupDockerDebian
        elif [ "$distro" == "Ubuntu" ]; then
        setupDockerUbuntu
        elif [ "$distro" == "CentOS" ]; then
        setupDockerCentOS
        elif [ "$distro" == "Fedora" ]; then
        setupDockerFedora
        elif [ "$distro" == "Red Hat Enterprise Linux" ]; then
        setupDockerRHEL
        elif [ "$distro" == "SLES" ]; then
        setupDockerSLES
    else
        echo "Unsupported distro. Please install Docker manually"
        exit
    fi
    sleep 1
    setupDockerCompose
    sleep 1
    docker --version
    echo "Docker installed"
    sleep 1
    docker-compose -version
    echo "Docker compose installed"
    sleep 1
    echo "Thank you for using this script to install Docker"
    echo "Made by Nick de Jager"
    echo "E-Mail: info@nickdejager.nl"
}

main
