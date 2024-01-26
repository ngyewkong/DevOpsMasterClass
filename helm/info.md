# HELM: K8S Package Manager

- Chart: Helm Package which contains all the resource definitions necessary to run an application, tool or service inside of a k8s cluster
- Repository: Place where charts can be collected and shared

  - Repo Commands:
    - helm repo list: list the repositories
    - helm repo add some_repo_name some_repo_url: to add a repo
      - eg: helm repo add bitnami https://charts.bitnami.com/bitnami
      - eg: helm repo add brigade https://brigadecore.github.io/charts
    - helm repo remove some_repo_name: to remove a repo
      - eg: helm repo remove bitnami
    - helm search repo some_keyword --versions: search in repos for the keywords (can be in chart name, description etc)
      - eg: helm search repo mysql
    - helm search hub some_keyword: search in the publicly available Artifact Hub (https://artifacthub.io/)
      - eg: helm search hub nginx
      - eg: helm search hub nginx | ec -l [do a count of lines from the search results]

- Release: Instance of a chart running in a k8s cluster

- Charts can be installed as many times in the same cluster.
- New installation -> New Release created
