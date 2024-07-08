# Container Resources Lab

## Resource Requests

- vim lab-resource-req-pod.yml
- kubectl apply -f lab-resource-req-pod.yml
- vim lab-resource-req-pod.yml & update the last 2 pods to 750m
- kubectl apply -f lab-resource-req-pod.yml
  - Error from server (Invalid): error when applying patch
  - due to exceeding total cpu cores cannot update
- kubectl delete pod frontend-1 frontend-2 frontend-3 frontend-4
- kubectl delete -f lab-resource-req-pod.yml
- kubectl apply -f lab-resource-req-pod.yml
- kubectl get pods -o wide
  - will see frontend-1 frontend-2 are running the other 2 pods are pending state
  - k8s did not schedule these pods (as k8s do not have the resources to schedule the 2 pods with 750m cpu)

## Resource Limits

- vim lab-resource-limits-pod.yml
- kubectl apply -f lab-resource-limits-pod.yml
