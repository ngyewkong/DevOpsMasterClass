# Upgrade k8s Runbook

## Upgrade Master Node

- if getting couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp [::1]:8080: connect: connection refused
  - execute "export KUBECONFIG=/etc/kubernetes/admin.conf"
- kubectl get nodes
- drain master node
  - kubectl drain k8s-master-01 --ignore-daemonsets
- upgrade kubeadm
  - sudo apt-get update
  - sudo apt-get install -y --allow-change-held-packages kubeadm=1.30.1-1.1 (upgrade to kubeadm v1.30.1-1.1)
- upgrade plan
  - sudo kubeadm upgrade plan v1.30.1-1.1
- apply plan
  - sudo kubeadm upgrade apply v1.30.1
- upgrade kubelet & kubectl
  - sudo apt-get update
  - sudo apt-get install -y --allow-change-held-packages kubelet=1.30.1-1.1 kubectl=1.30.1-1.1
- restart the kubelet
  - sudo systemctl daemon-reload
  - sudo systemctl restart kubelet
- check node upgraded version
  - kubectl get nodes
- uncordon drained node
  - kubectl uncordon k8s-master-01

## Upgrade Worker Node

- if getting couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp [::1]:8080: connect: connection refused
  - execute "export KUBECONFIG=/etc/kubernetes/kubelet.conf"
- ensure upgrade of worker nodes is done via rolling update manner (to have no downtime)
- one node at a time
- drain worker node
  - kubectl drain k8s-worker-02 --ignore-daemonsets --force
- upgrade kubeadm
  - sudo apt-get update
  - sudo apt-get install -y --allow-change-held-packages kubeadm=1.30.1-1.1 (upgrade to kubeadm v1.30.1-1.1)
- upgrades the local kubelet config for worker nodes
  - sudo kubeadm upgrade node
- upgrade kubelet & kubectl
  - sudo apt-get update
  - sudo apt-get install -y --allow-change-held-packages kubelet=1.30.1-1.1 kubectl=1.30.1-1.1
- restart the kubelet
  - sudo systemctl daemon-reload
  - sudo systemctl restart kubelet
- check node upgraded version from master node
  - kubectl get nodes
- uncordon drained node
  - kubectl uncordon k8s-worker-02
