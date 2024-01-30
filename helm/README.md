\***\*\*\*\*\*** Install Docker CE Edition \***\*\*\*\*\***

1. Uninstall old versions

sudo apt-get remove docker docker-engine docker.io containerd runc

2. Update the apt package index

sudo apt-get update

sudo apt-get install \
 apt-transport-https \
 ca-certificates \
 curl \
 gnupg \
 lsb-release

3. Add Docker’s official GPG key:
   sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

4. Use the following command to set up the stable repository

echo \
 "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

5. Install Docker Engine

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt install docker.io

6. Verify the Docker version

docker --version

\***\*\*\*\*\*** Install KubeCtl \***\*\*\*\*\***

1. Download the latest release

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

2. Install kubectl

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

3. Test to ensure the version you installed is up-to-date:

kubectl version --client

\***\*\*\*\*\*** Install MiniKube \***\*\*\*\*\***

1. Download Binary

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64

2. Install Minikube

sudo install minikube-linux-amd64 /usr/local/bin/minikube

3. Verify Installation

minikube version

4. Start Kubernetes Cluster

sudo apt install conntrack
minikube start --driver=docker --force

5. Get Cluster Information

kubectl config view
kubectl get nodes

\***\*\*\*\*\*** Install Helm \***\*\*\*\*\***
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
helm version
