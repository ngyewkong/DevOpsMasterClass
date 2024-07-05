# Network Policies Lab

## On Master Node

- kubectl get ns
- kubectl create ns network-policy
- kubectl get ns --show-labels
- kubectl label ns network-policy role=test-network-policy (add label to ns)
- vim network-policy-pod.yml
- kubectl apply -f network-policy-pod.yml
- kubectl get pods -o wide -n network-policy
- kubectl exec -n network-policy busybox-pod -- curl 192.168.118.72
  - shld see the nginx default page
- vim network-policy.yml
- kubectl apply -f network-policy.yml
- kubectl get networkpolicy -n network-policy -o wide
  - sample-network-policy
- kubectl exec -n network-policy busybox-pod -- curl 192.168.118.72
  - will not be able to curl as no ingress or egress are set (ingress part is commented)
- uncomment the ingress part
- kubectl apply -f network-policy.yml
- kubectl exec -n network-policy busybox-pod -- curl 192.168.118.72
  - shld see the nginx default page
