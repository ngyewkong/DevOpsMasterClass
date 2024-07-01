# Static Pods & Mirror Pods Lab

## Static Pods

### On Master Node

- Since static pods are not managed by the control plan / master node, will need to need to check the worker nodes via the master nodes
  - kubectl get nodes

### On Worker Node

- ssh into any of the worker nodes (eg k8s-worker-02)
- create the manifest yaml file at specific location in worker node (/etc/kubernetes/manifests)
  - cd /etc/kubernetes/manifests
  - ls -ltr
  - vim static-pod.yml
- by default, will auto run the static pod
  - but if you want it to be applied immediately
    - sudo systemctl restart kubelet

### On Master Node

- check if static pod is created
  - kubectl get pods -o wide
  - will see nginx-static-pod-k8s-worker-02 running
  - this is the mirror pod of the static pod running on k8s-worker-02 node
  - kubectl describe pod nginx-static-pod-k8s-worker-02
- delete the nginx-static-pod-k8s-worker-02 pod
  - will see that pod is not deleted on worker node
  - reason: cannot change static pod state via mirror pod
