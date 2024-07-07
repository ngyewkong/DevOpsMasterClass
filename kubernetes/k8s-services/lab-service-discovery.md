# Service Discovery Lab

- kubectl get svc -o wide
  - nginx-service ClusterIP 10.96.99.35 <none> 80/TCP 2d19h app=frontend
  - nginx-service-nodeport NodePort 10.104.93.145 <none> 80:30099/TCP 11m app=frontend
- vim dns-svc-pod.yml
- kubectl get ns
- kubectl create ns service-namespace
- kubectl apply -f dns-svc-pod.yml
- kubectl get pods -o wide --show-labels -n service-namespace
- kubectl exec -n service-namespace svc-test-dns -- curl nginx-service:8080
  - could not resolve host (this service (nginx-service) is not in the same namespace as the pod executing the curl)
  - have to provided the Service FQDN instead of service name only
- kubectl exec -n service-namespace svc-test-dns -- curl nginx-service.default.svc.cluster.local:8080
  - able to access the default nginx page
