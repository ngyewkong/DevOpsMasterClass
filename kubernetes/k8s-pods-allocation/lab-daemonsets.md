# DaemonSets Lab

## On Master Node / Control Plane

- vim daemonsets.yml
- kubectl apply -f daemonsets.yml
- kubectl get daemonsets
- kubectl get pods -o wide
  - see that both workers nodes have logging pods running
- kubectl describe pod logging-6mrsx
  - will see under Labels: app=httpd-logging
- kubectl describe daemonsets logging
  - will see under Selector: app=httpd-logging
  - have to make sure selector matches with the labels of the pods
