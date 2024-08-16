# Helm Advanced Charts

## Manage Chart Dependencies

- An App with Web Frontend & API Backend
  - when deploying helm chart for the web frontend -> backend shld also be deployed
  - chart dependency: web app chart is dependent on backend chart
  - during helm install
    - k8s cluster will create both frontend and backend pods
  - using dependencies keyword set in Chart.yaml
  - update dependencies (this will download the .tar.gz for the dependencies charts - mysql & rabbitmq)
    - helm dependency update my-first-chart
      - mysql-11.1.15.tgz rabbitmq-14.6.6.tgz
  - install new release
    - helm install custom-rel my-first-chart/
    - helm ls
      - NAME: custom-rel
      - LAST DEPLOYED: Fri Aug 16 2024
      - NAMESPACE: default
      - STATUS: deployed
      - REVISION: 1
    - kubectl get pods
      - NAME READY STATUS RESTARTS AGE
      - custom-rel-my-first-chart-869945c8cc-b8ntz 1/1 Running 0 4m28s
      - custom-rel-mysql-0 1/1 Running 0 4m28s
      - custom-rel-rabbitmq-0 1/1 Running 0 4m28s

## Conditional Chart Dependency

- to put conditions on dependencies -> need to set condition key-value pair in Chart.yaml dependencies
  - need to use values.yaml to pass in the values
  - eg disable mysql
    - condition: mysql.enabled
    - it is set to false in values.yaml
    - when installing, helm will not create the pod for mysql
    - helm install conditional-dep my-first-chart/
      - NAME: conditional-dep
      - LAST DEPLOYED: Fri Aug 16 2024
      - NAMESPACE: default
      - STATUS: deployed
      - REVISION: 1
    - kubectl get pods
      - NAME READY STATUS RESTARTS AGE
      - conditional-dep-my-first-chart-d6549f986-48t2d 1/1 Running 0 2m31s
      - conditional-dep-rabbitmq-0 1/1 Running 0 2m31s
  - eg enable mysql disable rabbitmq
    - helm uninstall conditional-dep my-first-chart/
    - helm install conditional-dep my-first-chart/
      - NAME: conditional-dep
      - LAST DEPLOYED: Fri Aug 16 2024
      - NAMESPACE: default
      - STATUS: deployed
      - REVISION: 1
    - kubectl get pods (see myysql pod is created but rabbitmq pod is not created)
      - NAME READY STATUS RESTARTS AGE
      - conditional-dep-my-first-chart-d6549f986-9gqph 1/1 Running 0 63s
      - conditional-dep-my-first-chart-d6549f986-gfkds 1/1 Running 0 63s
      - conditional-dep-my-first-chart-d6549f986-p4n2b 1/1 Running 0 63s
      - conditional-dep-mysql-0 1/1 Running 0 63s

## Pass Values to Dependencies at Runtime

## Child to Parent Chart Data Exchange
