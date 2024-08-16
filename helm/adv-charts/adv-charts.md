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
      - LAST DEPLOYED: Fri Aug 16 15:46:44 2024
      - NAMESPACE: default
      - STATUS: deployed
      - REVISION: 1
    - kubectl get pods
      - NAME READY STATUS RESTARTS AGE
      - custom-rel-my-first-chart-869945c8cc-b8ntz 1/1 Running 0 4m28s
      - custom-rel-mysql-0 1/1 Running 0 4m28s
      - custom-rel-rabbitmq-0 1/1 Running 0 4m28s

## Conditional Chart Dependency

## Pass Values to Dependencies at Runtime

## Child to Parent Chart Data Exchange
