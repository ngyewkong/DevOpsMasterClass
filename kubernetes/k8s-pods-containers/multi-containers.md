# Multi-Container Labs

- vim lab-multi-containers.yml
- kubectl apply -f lab-multi-containers.yml
- kubectl get pods -o wide
- kubectl describe pods two-containers
- will see pod not being ready (1/2) as the second container has exited after completing the command
