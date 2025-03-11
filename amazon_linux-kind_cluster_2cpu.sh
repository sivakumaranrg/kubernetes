#!/bin/bash

# Step 1: Update system packages
echo "Updating system packages..."
sudo dnf update -y

# Step 2: Remove conflicting curl-minimal package (use --allowerasing)
echo "Removing conflicting curl-minimal package..."
sudo dnf remove -y curl-minimal
sudo dnf install -y curl --allowerasing

# Step 3: Install required dependencies
echo "Installing required dependencies..."
sudo dnf install -y tar wget unzip

# Step 4: Install Docker
echo "Installing Docker..."
sudo dnf install -y docker

# Step 5: Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl enable --now docker

# Step 6: Install Docker Compose (optional but recommended)
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Step 7: Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/v1.25.3/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Step 8: Install kind
echo "Installing kind..."
curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x /usr/local/bin/kind

# Step 9: Create the kind cluster with 2 worker nodes
echo "Creating kind cluster with 2 worker nodes..."
cat <<EOF | kind create cluster --name devops-cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

# Step 10: Set kubeconfig context to the kind cluster
echo "Setting kubeconfig context to the kind cluster..."
export KUBEVIRT_KUBEVIRT_KUBECONFIG_PATH=~/.kube/kind-config-devops-cluster

# Step 11: Verify nodes in the cluster
echo "Verifying nodes in the cluster..."
kubectl get nodes
