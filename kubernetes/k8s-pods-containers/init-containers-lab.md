# Init Containers Lab

- vim lab-init-container.yml
- kubectl apply -f lab-init-containers.yml
- kubectl get -f lab-init-containers.yml
  - will see the init containers status Init:0/2
- kubectl get services
  - do not see myservice and mydb services
- vim lab-init-containers-dep.yml
- kubectl apply -f lab-init-containers-dep.yml
- kubectl get services
  - see that mydb & myservice service obj are created
- kubectl get -f lab-init-containers.yml
  - pod status for app is running
