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

- passing in parent values to child charts
- add it to values.yaml (under myysql)
  - eg. add db credentials in parent values.yaml and pass it to the child chart during install
  - helm install parent-child-dep my-first-chart
    - NAME: parent-child-dep
    - LAST DEPLOYED: Fri Aug 16 21:45:36 2024
    - NAMESPACE: default
    - STATUS: deployed
    - REVISION: 1
  - kubectl get pods
    - NAME READY STATUS RESTARTS AGE
    - parent-child-dep-my-first-chart-69d4bcc99-cxr28 1/1 Running 0 2m9s
    - parent-child-dep-my-first-chart-69d4bcc99-g9h6l 1/1 Running 0 2m9s
    - parent-child-dep-my-first-chart-69d4bcc99-wltb8 1/1 Running 0 2m9s
    - parent-child-dep-mysql-0 1/1 Running 0 2m9s
  - kubectl get svc
    - NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S) AGE
    - parent-child-dep-my-first-chart ClusterIP 10.102.103.42 <none> 80/TCP 2m11s
    - parent-child-dep-mysql ClusterIP 10.108.33.65 <none> 3306/TCP 2m11s
    - parent-child-dep-mysql-headless ClusterIP None <none> 3306/TCP 2m11s
  - eg. add customization in values.yaml (change Network from ClusterIP to NodePort)
    - helm uninstall parent-child-dep my-first-chart
    - helm install parent-child-dep my-first-chart
    - kubectl get svc (parent-child-dep-mysql should be NodePort type instead of ClusterIP)
      - NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S) AGE
      - parent-child-dep-my-first-chart ClusterIP 10.98.114.220 <none> 80/TCP 3m56s
      - parent-child-dep-mysql NodePort 10.107.43.240 <none> 3306:31085/TCP 3m56s
      - parent-child-dep-mysql-headless ClusterIP None <none> 3306/TCP 3m56s

## Child to Parent Chart Data Exchange

- read smth from child to parent
- have to use "import-values" syntax in Chart.yaml
  - import-values:
    - child: image # to reference the image key from child chart
    - parent: mysql_image # save the output to mysql_image which can be referenced in deployment.yaml
- in deployment.yaml
  - {{- .Values.mysql_image.repository | nindent 4 | quote }}
    - kind: Deployment"\n bitnami/mysql"
