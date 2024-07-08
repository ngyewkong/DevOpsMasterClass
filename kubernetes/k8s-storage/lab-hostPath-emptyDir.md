# HostPath & EmptyDir K8S Volume Lab

## HostPath Volume Type

### On Master Node

- vim hostpath-vol-mount.yml
- kubectl apply -f hostpath-vol-mount.yml
- kubectl get pods -o wide
- kubectl describe pod hostpath-pod

### On Worker Node

- ls /var/tmp
- cat /var/tmp/output.txt
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:50:57 UTC 2024
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:52:19 UTC 2024

### On Master Node

- kubectl delete -f hostpath-vol-mount.yml

### On Worker Node

- ls /var/tmp
- cat /var/tmp/output.txt
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:52:19 UTC 2024
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:55:39 UTC 2024
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:55:42 UTC 2024

### On Master Node

- restart the pod
  - kubectl apply -f hostpath-vol-mount.yml

### On Worker Node

- ls /var/tmp
- cat /var/tmp/output.txt
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:55:42 UTC 2024
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:56:01 UTC 2024
  - Hello Team, This is Sample File for HostVolume - Mon Jul 8 13:56:29 UTC 2024
- can see that the output.txt is persisted

## EmptyDir Volume Type

### On Master Node

- vim emptydir-vol.yml
- kubectl apply -f emptydir-vol.yml
- kubectl get pods -o wide
- kubectl describe pod redis-emptydir
- kubectl exec -it redis-emptydir -- /bin/bash
- ls /data/redis
- echo "Hello Team. This file is created and saved in /data/redis of an emptyDir mountPath." >> emptyDir-output.txt
- exit
- kubectl delete -f emptydir-vol.yml
- kubectl apply -f emptydir-vol.yml
- kubectl exec -it redis-emptydir -- /bin/bash
- ls /data/redis
  - the empptyDir-output.txt is no longer persisted
  - emptyDir is a dynamic volume
