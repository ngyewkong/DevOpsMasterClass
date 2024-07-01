# Hands-On K8s Object (kubectl)

- in the single node cluster
  - kubectl create -f pod.yaml
  - kubectl api-resources (get the list of supported resources types)
  - kubectl get po or kubectl get pods
  - kubectl get pods node-draining-test-pod -o wide / -o json / -o yaml (different output formats)
  - kubectl describe pods node-draining-test-pod
  - kubectl exec node-draining-test-pod -c nginx -- cat /etc/nginx/nginx.conf (to execute cat inside the container filesystem)
  - kubectl delete pods node-draining-test-pod (delete pod)
