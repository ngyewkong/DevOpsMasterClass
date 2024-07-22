# HELM: K8S Package Manager

- Chart: Helm Package which contains all the resource definitions necessary to run an application, tool or service inside of a k8s cluster
- Repository: Place where charts can be collected and shared
- Release: Instance of a chart running in a k8s cluster
  - Charts can be installed as many times in the same cluster.
  - New installation -> New Release created
- Repo Commands:
  - helm repo list: list the repositories
  - helm repo add some_repo_name some_repo_url: to add a repo
    - eg: helm repo add bitnami https://charts.bitnami.com/bitnami
    - eg: helm repo add brigade https://brigadecore.github.io/charts
  - helm repo remove some_repo_name: to remove a repo
    - eg: helm repo remove brigade
  - helm search repo some_keyword --versions: search in repos for the keywords (can be in chart name, description etc)
    - eg: helm search repo mysql
  - helm search hub some_keyword: search in the publicly available Artifact Hub (https://artifacthub.io/)
    - eg: helm search hub nginx
    - eg: helm search hub nginx | ec -l [do a count of lines from the search results]

## Executing Services with HELM

- https://artifacthub.io/packages/helm/bitnami/redis
- helm repo add bitnami https://charts.bitnami.com/bitnami
- helm install my-redis bitnami/redis --version 19.6.1
  - NAME: my-redis
  - LAST DEPLOYED: Mon Jul 22 12:59:44 2024
  - NAMESPACE: default
  - STATUS: deployed
  - REVISION: 1
  - TEST SUITE: None
  - NOTES:
  - CHART NAME: redis
  - CHART VERSION: 19.6.1
  - APP VERSION: 7.2.5
- kubectl get pods
- kubectl get all (see the pods, services statefulSets being created by the chart)

### ** Please be patient while the chart is being deployed **

### Redis can be accessed on the following DNS names from within your cluster:

- my-redis-master.default.svc.cluster.local for read/write operations (port 6379)
- my-redis-replicas.default.svc.cluster.local for read-only operations (port 6379)

### To get your password run:

- export REDIS_PASSWORD=$(kubectl get secret --namespace default my-redis -o jsonpath="{.data.redis-password}" | base64 -d)

### To connect to your Redis server:

- Run a Redis-Client pod that you can use as a client:
  - kubectl run --namespace default redis-client --restart='Never' --env REDIS_PASSWORD=$REDIS_PASSWORD --image docker.io/bitnami redis:7.2.5-debian-12-r2 --command -- sleep infinity
- Use the following command to attach to the pod:
  - kubectl exec --tty -i redis-client --namespace default -- bash
- Connect using the Redis CLI:
  - REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h my-redis-master
  - REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h my-redis-replicas

### To connect to your database from outside the cluster execute the following commands:

- kubectl port-forward --namespace default svc/my-redis-master 6379:6379 &
- REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h 127.0.0.1 -p 6379

- helm list (to see list of deployments done by helm)

## Reusing Deployment Name

- helm install my-redis bitnami/redis --version 19.5.5 (older version)
  - Error: INSTALLATION FAILED: cannot re-use a name that is still in use
- kubectl create ns redis
- helm install -n redis my-redis bitnami/redis --version 19.5.5
  - can use the same deployment name to install but have to be in diff namespace
- helm list
  - still only see one my-redis with default namespace
- helm list --all-namespaces or helm list -A
  - will see both deployments with diff namespace info
- helm status my-redis or helm status my-redis -n redis (get back the info list from above)

## Provide Custom Values to HELM Chart

### clean up the space

- helm delete my-redis
- helm delete my-redis -n redis
- kubectl delete pod redis-client (this was created explicitly via kubectl previously)

### install mariadb

- https://artifacthub.io/packages/helm/bitnami/mariadb
- helm repo update (to update the bitnami repo)
- helm install my-mariadb bitnami/mariadb --version 19.0.1
  - this method do not pass in any custom values when executing the helm command
- kubectl create ns db
- go to values schema
- helm install -n db --values MariaDB-Custom-Values.yml my-mariadb bitnami/mariadb --version 19.0.1
  - NAME: my-mariadb
  - LAST DEPLOYED: Mon Jul 22 15:18:07 2024
  - NAMESPACE: db
  - STATUS: deployed
  - REVISION: 1
  - TEST SUITE: None
  - NOTES:
  - CHART NAME: mariadb
  - CHART VERSION: 19.0.1
  - APP VERSION: 11.4.2

### ** Please be patient while the chart is being deployed **

- Watch the deployment status using the command: kubectl get pods -w --namespace db -l app.kubernetes.io/instance=my-mariadb

### Services:

- echo Primary: my-mariadb.db.svc.cluster.local:3306
- Administrator credentials:
- Username: root
- Password : $(kubectl get secret --namespace db my-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)

### To connect to your database:

- Run a pod that you can use as a client:

  - kubectl run my-mariadb-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mariadb:11.4.2-debian-12-r0 --namespace db --command -- bash

- To connect to primary service (read/write):
  - mysql -h my-mariadb.db.svc.cluster.local -uroot -p helm-testdb

## Upgrade Services using HELM

- Obtain the password as described on the 'Administrator credentials' section and set the 'auth.rootPassword' parameter as shown below:
  - ROOT_PASSWORD=$(kubectl get secret --namespace db my-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d) helm upgrade --namespace db my-mariadb oci://registry-1.docker.io/bitnamicharts/mariadb --set auth.rootPassword=$ROOT_PASSWORD
  - helm upgrade -n db --values MariaDB-Custom-Values.yml my-mariadb bitnami/mariadb --version 19.0.0
    - NAMESPACE: db
    - STATUS: deployed
    - REVISION: 2
    - TEST SUITE: None
    - NOTES:
    - CHART NAME: mariadb
    - CHART VERSION: 19.0.0
    - APP VERSION: 11.4.2
      helm upgrade -n db my-mariadb bitnami/mariadb --version 19.0.0 (this will upgrade the deployment using default values instead)
- kubectl get pods
- helm list -A NAME
  - will see revision increase from 1 to 2

## HELM Release Records

- helm list -A
- kubectl get secrets -n db
  - my-mariadb Opaque 2 18m
  - sh.helm.release.v1.my-mariadb.v1 helm.sh/release.v1 1 18m
  - sh.helm.release.v1.my-mariadb.v2 helm.sh/release.v1 1 4m26s
- helm uninstall my-mariadb -n db
  - this will delete the past revisions state data
- helm uninstall my-mariadb -n db --keep-history
  - will keep the previous revision history
