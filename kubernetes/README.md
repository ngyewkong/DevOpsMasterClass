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
