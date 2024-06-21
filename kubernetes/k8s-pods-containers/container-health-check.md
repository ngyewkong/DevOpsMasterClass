# Container Health Check Lab

## Liveness Probe Lab

### Container Command Check

- create pod definition with liveness probe
  - vim lab-liveness-hc-pod.yml
- create the pod
  - kubectl apply -f lab-liveness-hc-pod.yml
- containers will be in running state
  - kubectl get pods -o wide
- after 60s
  - kubectl describe pod liveness-probe
    - will see one unhealthy event due to failing liveness probe check
  - kubectl get pods -o wide
    - show restart count +1

### HTTP GET Check

- check the liveness-probe-http pod
  - kubectl describe pod liveness-probe-http
- verify by curling the ip of the pod

## Startup Probe Lab

- vim lab-startup-hc-pod.yml
- kubectl apply -f lab-startup-hc-pod.yml
- kubectl get pods -o wide
- the first get pods will show the pod in not-ready but running state
  - this is cos the first startup probe did not get success
- after some time will be both ready and running state

## Readiness Probe Lab

- vim lab-readiness-hc-pod.yml
- kubectl apply -f lab-readiness-hc-pod.yml
- kubectl get pods -o wide
  - pod is ready and running
- kubectl delete -f lab-readiness-hc-pod.yml
- vim lab-readiness-hc-pod.yml
  - change readiness probe port to 9090
- kubectl apply -f lab-readiness-hc-pod.yml
- kubectl get pods -o wide
  - pod will be running but not ready
- kubectl describe pod hc-probe
  - Readiness probe failed: Get "http://the_pod_ip:9090/"
