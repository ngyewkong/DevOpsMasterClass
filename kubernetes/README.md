# Kubernetes

## Introduction

- k8s - Orchestration Tool
- manage state of containers
  - start containers on specific nodes
  - restart containers when it get killed
  - move containers from one node to another
- features:
  - automated scheduling: k8s provides adv scheduler to launch container on cluster nodes based on their resource requirements & other constraints
  - healing capabilities: k8s will replace and reschedule containers when nodes die, k8s do not allow containers to use until they get ready
  - auto upgrade & rollback: k8s roll out changes to its app or configuration, monitoring app ensure k8s do not kill all instance, if smth go wrong, can rollback the change
  - horizontal scaling: k8s can scale up & down the app as per requirements with a simple command or ui or based on CPU usage automatically
  - storage orchestration: k8s can mount the storage sys of user choice, can opt for either local storage or public cloud provider
  - secret & config management: k8s can help to deploy & update secrets & app config without rebuilding the app image & without exposing secrets in the stack configuration
- k8s can be ran:

  - On-Premise (own DC)
  - Public Cloud (AWS, GCP, Azure, Digital Ocean)
  - Hybrid Cloud

## Architecture

- k8s follows Master-Slave Architecture
- Master Node: Responsible for mgmt of k8s cluster, Entrypoint for all admin tasks
  - can have multi-master nodes
- Workflow: CLI/APIs/UI req -> Master Node/s -> Worker Nodes
  - Master Node: Control Plane components consist controller, api-server, scheduler, etcd
    - kube-api-server: Entrypoint for all REST commands used to control the cluster, only interaction point with k8s
    - etcd: Distributed key-value-store which stores the cluster state, used as backend service for k8s, provides HA of data related to cluster state (impt to externalise the etcd in the event of master node failure)
    - kube-scheduler: Regulate the tasks on slave nodes, store resource usage information for each slave node
    - kube-controller: Runs multiple controller utility in a single process, carry automated tasks in k8s cluster
      - kube-control-manager
  - Worker Node: kube-proxy, kublet & pods
    - kublet: k8s agent executed on worker nodes, gets config of a pod from the api-server from master node and ensures the described containers are up & running
    - pods: group of one or more containers with shared storage/network & spec for how to run the containers
      - share the same shared content and IP but reach other pods via localhost
      - single pod can run on multiple machines and single machine can run multiple pods
    - kube-proxy: runs on each node to deal with individual host sub-netting and ensure that the services are available to external parties

## Installation

- HA deployment (1 Master 2 Slaves)

  - setup using kubeadm

    - ssh into master node
      - follow doc https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
      - sudo apt-get update
      - sudo apt-get install -y apt-transport-https ca-certificates curl gpg
      - curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      - echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
      - sudo apt-get update
      - sudo apt-get install -y kubelet kubeadm kubectl
      - sudo apt-mark hold kubelet kubeadm kubectl
      - cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
      - overlay
      - br_netfilter
      - EOF
      - sudo modprobe overlay
      - sudo modprobe br_netfilter
      - cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
      - net.bridge.bridge-nf-call-iptables = 1
      - net.ipv4.ip_forward = 1
      - net.bridge.bridge-nf-call-ip6tables = 1
      - EOF
      - sudo sysctl --system
      - sudo apt-get update && sudo apt-get install -y containerd
      - sudo mkdir -p /etc/containerd
      - containerd config default | sudo tee /etc/containerd/config.toml
      - sudo systemctl restart containerd
      - sudo systemctl status containerd
    - initialize k8s control plane (with an IP range)
      - kubeadm init --pod-network-cidr=192.168.0.0/16
    - setup kubeconfig on the machine (regular user)
      - mkdir -p $HOME/.kube
      - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      - sudo chown \$(id -u):\$(id -g) $HOME/.kube/config
    - setup kubeconfig on the machine (root user)
      - export KUBECONFIG=/etc/kubernetes/admin.conf
    - deploy pod network
      - kubectl apply -f podnetwork.yaml (refer to https://kubernetes.io/docs/concepts/cluster-administration/addons/)
      - kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml (using calico)
      - kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml
      - watch kubectl get pods -n calico-system (check if calico is up)
      - kubectl get pods --all-namespaces
      - kubectl get nodes -o wide
    - to get the join token for worker node
      - kubeadm token create --print-join-command
    - install kubeadm on worker nodes (follow above installation steps used in master node)
    - join worker nodes to cluster using kubeadm (ssh into worker nodes and execute)
      - kubeadm join MasterNodeIP:6443 --token someautogentoken --discovery-token-ca-cert-hash sha256:someSHA

- Single Node deployment (MiniKube k8s cluster)
  - Install Docker (Follow the docker docs)
  - Install kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
    - curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    - sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    - kubectl version --client
  - Install MiniKube
    - wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    - sudo cp minikube-linux-amd64 /usr/local/bin/minikube
    - sudo chmod +x /usr/local/bin/minikube
    - minikube version
    - sudo apt install conntrack
    - minikube start --force (on digital ocean)
    - kubectl is now configured to use "minikube" cluster and "default" namespace by default
    - minikube status
    - kubectl config view (view the certificate, namespace, user, context)
  - Install Fish (optional) (terminal interactive ui)
    - sudo apt install fish
    - fish (to use it in the current cli window)

## Useful CLI Commands

- kubectl create deployment deploymentName --image=imageName
  - kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.10
- kubectl get deployment
- kubectl get pods -A
- expose container to external (need to create a k8s service which create the access point)
  - kubectl expose deployment deploymentName --type=ServiceType --port=ListeningPodPort
  - kubectl expose deployment hello-node --type=LoadBalancer --port=8080
- kubectl get services
- minikube service hello-node / minikube service list
  - NAMESPACE | NAME | TARGET PORT | URL
  - default | hello-node | 8080 | http://192.168.49.2:32024
- kubectl delete service hello-node
- kubectl delete deployment hello-node

## Namespaces

- Namespaces are virtual cluster backed by the same physical cluster
- k8s objects (pods & containers) live in namespace
- Namespaces are used to separate & organise obj in k8s
- list all the namespaces
  - kubectl get namespaces
- All clusters have default namespace
- specify namespace to resources (--namespace or -n flag)
  - kubectl get pods --namespace NAMESPACE (this will return pods in the specified namespace)
  - kubectl get pods (this will return all pods in default namespace)
  - kubectl get pods --all-namespaces (this will all pods in all namespaces)
- can use namespaces as a logical bind or organisation
- create namespace in k8s
  - kubectl create namespace NAMESPACE
    - kubectl create namespace dev
- kubeadm (cluster setup tool for following best practices k8s cluster creation)
  - --config to pass a custom config file

## Cluster Management

- App HA in k8s cluster
  - Infra HA
  - Cluster HA
    - Need MULTIPLE Control Planes (Master Nodes)
    - Need Load Balancer to communicate among multiple control planes & worker nodes will also comm to the load balancer
    - Stacked etcd (more popular model)
      - each master node has their own etcd server
    - External etcd
      - each master node control plane only have the kube-api-server & other components
      - setup another node or another cluster for etcd server

## K8s Management Tools

- kubectl
  - official k8s cli
  - the other way is the rest api
- kubeadm
  - used to create k8s cluster
- minikube
  - k8s dev tool
  - help to setup k8s cluster in a single node quickly for dev work
- helm
  - k8s template and package mgmt tool
  - ability to convert k8s objects into reusable templates
  - ability to provide complex multi-config templates with cross connectivity (interdependency)
- kompose
  - tranlates docker compose files into k8s object
  - ability to ship docker containers to k8s
- kustomize
  - configuration mgmt tool for k8s obj config
  - similar to helm
  - ability to create reusable templates for k8s
