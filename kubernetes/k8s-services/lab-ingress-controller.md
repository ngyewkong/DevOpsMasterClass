# Ingress Controller Lab

## Setting up the deployments & services

- vim nginx-deployment.yml
- kubectl apply -f nginx-deployment.yml
- kubectl describe deployment.apps/nginx-official-deployment
- vim nginx-deployment-svc.yml
- kubectl apply -f nginx-deployment-svc.yml
- kubectl get svc
- vim magic-nginx-deployment.yml
- vim magic-nginx-deployment-svc.yml
- kubectl apply -f magic-nginx-deployment.yml
- kubectl apply -f magic-nginx-deployment-svc.yml
- kubectl describe svc magical-nginx
  - NodePort: http 31304/TCP
  - Endpoints: 192.168.7.132:80
- curl 192.168.7.132:31304 (magical-nginx)
- curl 192.168.7.148:31303 (nginx-official-service)

## Creating the Ingress Controller

- vim ingress-controller.yml
- kubectl apply -f ingress-controller.yml
  - ingress.networking.k8s.io/nginx-rules created
- kubectl describe ingress nginx-rules
  - Rules:
  - Host Path Backends
  - nginx-official.example.com / nginx-official-service:80 (192.168.7.148:80)
  - magical-nginx.example.com / magical-nginx:80 (192.168.7.132:80)
- will be able to access directly from the hostname
