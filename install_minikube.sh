#!/bin/bash

set -e  # Exit on any error

### Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    echo "Unsupported Linux distribution"
    exit 1
fi

echo "Detected OS: $OS $VERSION"

### Install dependencies
echo "Installing required dependencies..."
if [[ "$OS" =~ ^(ubuntu|debian)$ ]]; then
    sudo apt-get update -y
    sudo apt-get install -y curl wget apt-transport-https conntrack
elif [[ "$OS" =~ ^(centos|rhel|rocky|almalinux)$ ]]; then
    sudo yum install -y wget conntrack
    if yum list installed curl-minimal &>/dev/null; then
        echo "Conflicting curl-minimal detected. Replacing it with curl..."
        sudo dnf swap -y curl-minimal curl
    fi
    sudo yum install -y curl --allowerasing
else
    echo "Unsupported Linux distribution"
    exit 1
fi

### Enable required kernel modules for Minikube
echo "Configuring kernel modules..."
sudo modprobe br_netfilter
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee /etc/sysctl.d/k8s.conf
sudo sysctl --system > /dev/null 2>&1

### Install Kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    echo "Kubectl installed successfully."
else
    echo "Kubectl is already installed."
fi

### Install Minikube
if ! command -v minikube &> /dev/null; then
    echo "Installing Minikube..."
    curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
    chmod +x minikube-linux-amd64
    sudo mv minikube-linux-amd64 /usr/local/bin/minikube
    echo "Minikube installed successfully."
else
    echo "Minikube is already installed."
fi

### Ensure Minikube is Executable & Fix PATH Issues
echo "Ensuring Minikube is executable..."
sudo chmod +x /usr/local/bin/minikube
sudo chown root:root /usr/local/bin/minikube

# Add /usr/local/bin to PATH if not present
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    echo "Adding /usr/local/bin to PATH..."
    echo 'export PATH=$PATH:/usr/local/bin' | sudo tee -a /etc/profile.d/minikube.sh
    source /etc/profile.d/minikube.sh
    export PATH=$PATH:/usr/local/bin
    echo "Updated PATH: $PATH"
fi

# Reload shell path
hash -r

### Start Minikube
if ! minikube status &>/dev/null; then
    echo "Starting Minikube..."
    sudo -E minikube start --driver=none
    echo "Minikube started successfully."
else
    echo "Minikube is already running."
fi

### Verify Installation
echo "Kubectl version:"
kubectl version --client --output=yaml || echo "Kubectl not found!"

echo "Minikube version:"
minikube version || echo "Minikube not found!"

echo "Minikube installation complete!"
