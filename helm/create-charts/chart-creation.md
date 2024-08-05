# Create HELM Charts

- helm create name_of_chart
  - eg helm create my-first-chart
  - this will create a folder dir (my_first_chart) with charts & templates sub dir
  - this will also create Chart.yaml & values.yaml
    - Chart.yaml -> define structure of chart
    - values.yaml -> pass in dynamic values
  - by default, use the nginx image
- helm install deployment_name name_of_chart
  - eg helm install custom-deployment my-first-chart (note: \_ is not allowed)
    - NAME: custom-deployment
    - NAMESPACE: default
    - STATUS: deployed
    - REVISION: 1
  - the notes from deployment come from NOTES.txt inside the templates folder dir
  - the Chart.yaml contains the metadata about the deployment (apiversion, name, desc)
