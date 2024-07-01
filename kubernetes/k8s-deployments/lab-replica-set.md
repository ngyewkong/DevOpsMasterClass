# ReplicaSet & Bare Pods Lab

## On Master Node

- vim replica-set.yml
- kubectl apply -f replica-set.yml
- kubectl get replicaset.apps/myapp-replicas or rs//myapp-replicas
- kubectl get pods -o wide
- kubectl describe rs/myapp-replicas
- scaling up
  - kubectl scale --replicas=10 rs/myapp-replicas
- scaling down
  - kubectl scale --replicas=2 rs/myapp-replicas
- vim barePod.yml
  - note the bare pods share the same label as the one in ReplicaSet
- kubectl apply -f barePod.yml
- kubectl describe pod mypod1
  - will see that Controlled By: ReplicaSet/myapp-replicas
