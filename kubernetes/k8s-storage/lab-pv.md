# PersistentVolume & PersistentVolumeClaim Lab

## On Master Node

### Create Storage Class

- vim localhost-sc.yml
- kubectl apply -f localhost-sc.yml
- kubectl describe storageclass.storage.k8s.io/local-storage

### Create PersistentVolume

- vim pv.yml
- kubectl apply -f pv.yml
- kubectl describe persistentvolume/my-persistent-vol
  - StorageClass: local-storage
  - Source:
  - Type: HostPath (bare host directory volume)
  - Path: /var/tmp
- kubectl get pv -o wide

### Create PersistentVolumeClaim

- vim pvc.yml
- kubectl apply -f pvc.yml
- kubectl describe pvc my-pvc
- kubectl get pvc -o wide

### Create Pod that will consume the PVC

- vim pv-pod.yml
- kubectl apply -f pv-pod.yml
- kubectl get pv -o wide
  - shld see status changed from available to bound
  - shld also see claim changed from blank to default/my-pvc
- kubectl get pvc -o wide
  - shld see status changed from pending to bound
  - shld see volume changed from blank to my-persistent-vol
  - capacity changed from blank to 1Gi
  - access mode changed from blank to RWO

### Edit PVC

- kubectl edit pvc my-pvc
  - persistentvolumeclaim/my-pvc edited

### Delete Pod

- kubectl delete -f pv-pod.yml
- kubectl get pvc my-pvc -o wide
  - status is still bound after deletion of pod that is using the pvc resource
- kubectl delete -f pvc.yml
- kubectl get pv my-persistent-vol -o wide
  - status changed from bound to released
