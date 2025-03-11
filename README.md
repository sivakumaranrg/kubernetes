# kubernetes
#
#
## Install Git ###
sudo -i
yum install git -y

## Clone Git Repo ##
git clone https://github.com/sivakumaranrg/kubernetes.git

## Change directory into kubernetes ##
cd kubernetes

## Update executeable permission ##
chmod +x amazon_linux-kind_cluster.sh

## Run the script to create cluster ##
./amazon_linux-kind_cluster.sh



