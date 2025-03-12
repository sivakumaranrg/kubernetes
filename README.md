# Deploying Kind Clusters on AWS

This repository provides Bash scripts to install dependencies and set up Kubernetes clusters in different AWS environments.

## Scripts Overview

- **amazon_linux-kind_cluster_2cpu.sh**:  
  - Installs dependencies and deploys a Kind-based Kubernetes cluster on AWS.  
  - Runs with **1 control plane and 2 worker nodes** using `t3.medium` instances.  
  - **Minimum Requirements**: `t3.medium` (2 vCPUs, 4 GB RAM).  

- **kind_control-plane_free-tier.sh**:  
  - Installs dependencies and deploys a Kind-based Kubernetes cluster on AWS.  
  - Runs **only a control plane** on a `t2.micro` instance.  
  - **Suitable for AWS free tier** (1 vCPU, 1 GB RAM, best for lightweight workloads).  

## Prerequisites

Before running the scripts, complete the following setup on your EC2 instance:

- **Install Git**:
  ```bash
  yum install git -y
