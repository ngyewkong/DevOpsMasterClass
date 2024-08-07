# Create HELM Charts

- helm create name_of_chart
  - eg helm create my-first-chart
  - this will create a folder dir (my_first_chart) with charts & templates sub dir
  - this will also create Chart.yaml & values.yaml
    - Chart.yaml -> define structure of chart
    - values.yaml -> pass in dynamic values
  - by default, use the nginx image

# Install Helm Chart

- helm install deployment_name name_of_chart
  - eg helm install custom-deployment my-first-chart (note: \_ is not allowed)
    - NAME: custom-deployment
    - NAMESPACE: default
    - STATUS: deployed
    - REVISION: 1
  - the notes from deployment come from NOTES.txt inside the templates folder dir
  - the Chart.yaml contains the metadata about the deployment (apiversion, name, desc)
- to see the objects created
  - helm list -A (make sure only the custom deployment is listed)
  - kubectl get all
    - shld get a pod, service, deployment & replicaSet
- deployment.yaml is the main file of the chart which will deploy all the resources
- hpa.yaml is a conditional based resource
  - {{- if .Values.autoscaling.enabled }}
  - only if autoscaling is enabled in values.yaml file
- same goes for ingress.yaml
- service.yaml is not conditional by default
- templates folder contains all the yaml files needed to create the resources on k8s
- Helper file in templates dir
  - \_helpers.tpl contains the functions
    - {{- define "my-first-chart.fullname" -}} -> this is one function
  - use these functions to generate the final deployable version of the yaml files

# Values File in HELM

- variables resolved at runtime are referencing values.yaml
  - using eg .Values.ingress.enabled will look for ingress: enabled: true/false in the values.yaml
- will override the default set in the yaml files

# Package HELM Chart

- helm package my-first-chart/
  - this will package your chart in the current dir in tar.gz format
    - eg. my-first-chart-0.1.0.tgz
- possible to have a Chart have dependencies on other charts
  - need to use -u
    - eg. helm package my-first-chart/ -u (this will dl the latest versions of the dependencies before packaging your chart)
- can package and specify own path
  - need to use -d
    - eg. helm package my-first-chart/ -d /root/

# Validate HELM Chart

- helm lint my-first-chart
  - ==> Linting my-first-chart
  - [INFO] Chart.yaml: icon is recommended
  - 1 chart(s) linted, 0 chart(s) failed
- helm lint my-first-chart (after setting a wrong apiVersion for helm eg v2 to v20)
  - ==> Linting my-first-chart
  - [ERROR] Chart.yaml: apiVersion 'v20' is not valid. The value must be either "v1" or "v2"
  - [INFO] Chart.yaml: icon is recommended
  - [ERROR] Chart.yaml: chart type is not valid in apiVersion 'v20'. It is valid in apiVersion 'v2'
  - Error: 1 chart(s) linted, 1 chart(s) failed
