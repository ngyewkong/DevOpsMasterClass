# K8s Pods Scheduling Lab

## 1 Master Node, 2 Worker Nodes setup

### On Master Node

#### nodeSelector

- kubectl get nodes
- kubectl get pods -o wide
- vim node-selector.yml (refer to pods-scheduling.yml)
- kubectl apply -f node-selector.yml
- kubectl describe pod nginx-nodeselector
  - error: Warning FailedScheduling 94s default-scheduler 0/3 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }, 2 node(s) didn't match Pod's node affinity/selector.
- kubectl get nodes --show-labels (to get the labels attached to each node)
- Assigning labels to Nodes
  - kubectl label nodes (nodeName) (labelKey=labelValue)
    - kubectl label nodes k8s-worker-02 disktype=ssd
- kubectl get nodes --show-labels (disktype=ssd is added to k8s-worker-02)
- kubectl get pods -o wide (pod nginx-nodeselector running on k8s-worker-02)

#### nodeName

- vim node-name.yml (refer to pods-scheduling.yml)
- kubectl apply -f node-name.yml
- kubectl get pods -o wide

#### nodeSelector with Resource Requests

- vim resource-req.yml (refer to pods-scheduling.yml)
- kubectl apply -f resource-req.yml
- kubectl get pods -o wide
- cp resource-req.yml resource-req2.yml
- vim resource-req2.yml (update the pod name and cpu to exceed the number of cores on worker-02)
- kubectl apply -f resource-req2.yml
- kubectl get pods -o wide
- kubectl describe pod frontend-app-2
- vim resource-req3.yml (refer to the last pod definition in pods-scheduling.yml)
- kubectl apply -f resource-req3.yml
- kubectl get pods -o wide
  - will see this frontend-app-03 pod is running in k8s-worker-03 (as nodeSelector not specified)
