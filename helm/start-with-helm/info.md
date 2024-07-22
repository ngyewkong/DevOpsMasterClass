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

### Reusing Deployment Name

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
