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
