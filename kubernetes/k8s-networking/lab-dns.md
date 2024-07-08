# K8s DNS Lab

- kubectl get pods -o wide -n kube-system
  - coredns-7db6d8ff4d-2wh9c
- kubectl get services -o wide -n kube-system
  - kube-dns
- vim pod-dns.yml
- kubectl apply -f pod-dns.yml
- curl 192.168.118.71
  - get the default nginx page
- curl 192-168-118-71.default.pod.cluster.local
  - cannot resolve (we are curl from host machine not inside k8s pods)
- kubectl exec -it frontend-app sh
- curl 192-168-118-71.default.pod.cluster.local
  - will get the default nginx page
