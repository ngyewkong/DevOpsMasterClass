# Lab: Scaling using Replication Controller

## Master Node

- vim replication-controller.yml
- kubectl apply -f replication-controller.yml
- kubectl get pods -o wide
  - see 3 pods alipne-box-replicationcontroller running
- kubectl delete pod alpine-box-replicationcontroller-5tcqm (any one of the pod)
  - will see the pod terminating and another pod being spin up to maintain the 3 pods specified
- kubectl get replicationcontroller or kubectl get replicationcontroller/alpine-box-replicationcontroller (get status of the replication controller)
- scaling up
  - kubectl scale --replicas=6 replicationcontroller/alpine-box-replicationcontroller (scale replication controller to have 6 pods in total)
- kubectl get pods -o wide
- scale down
  - kubectl scale --replicas=2 replicationcontroller/alpine-box-replicationcontroller (scale down to 2 pods)
  - termination order will always delete pod that are created last first
- kubectl delete -f replication-controller.yml (delete the replication controller)
