# HELM: K8s Packaging Manager

## HELM Intro

- Package Manager running on top of K8s
- simplified micro services mgmt on k8s

- without helm
  - will need to use yaml files to configure k8s workloads
  - set up a new k8s workload -> create another yml file for that workload
  - all yml files created for k8s are static -> no dynamic parsing of parameters
  - error prone: humans need to edit the yml files
  - no consistency with human created yml files during deployments (no checking of reused ports, deployment names etc)
  - k8s do not maintain the revision history
    - deployment with 4 apps
      - upgrade v2 (only app a & d shld be upgraded)
      - in k8s will edit and redeploy all the yml files
- with helm
  - create helm chart and let helm deploy the app to the cluster
  - helm charts can be customized when deploying it on diff k8s clusters -> dynamic
  - helm charts -> templates -> configuration yml files
  - dynamic values can be supplied in an external file/s (input.yml) for diff env
  - single click deployment (multi-apps deployment)
  - reduce complexity of deployments
  - more reproducible deployments & results
  - ability to leverage k8s with single cli command
  - easy rollback to previous versions of the app
- helm charts & repos
  - chart is collection of files that describe a related set of k8s resources
  - can use helm cli commands on helm charts
  - can get charts from bitnami or own repo
- helm installation
  - k8s must be installed & pre-configured for helm to be usable
