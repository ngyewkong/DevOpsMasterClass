# Node Affinity Lab

## On Master Node

- vim node-affinity.yml
- kubectl get nodes --show-labels
- kubectl apply -f node-affinity.yml
- will see that nginx-node-affinity pod will only execute in k8s-worker-02
- while nginx-node-anti-affinity will only execute in k8s-worker-03
- as disktype=ssd label is only attached to k8s-worker-02
