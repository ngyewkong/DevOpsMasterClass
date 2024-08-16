# HELM Templates Syntax

## Comments in Templates

- Template Comments (for commenting out parts that use actions and require keywords to prevent rendering error)
  - {{- /\*
  - This is a comment.
  - \*/}}
- Yaml Comments (for normal comment)
  - "#"

## Actions in Templates

- whatever within {{ some_condition }} is an action which will be resolved at runtime
  - eg. {{ "Hi Team, some random text to show at runtime" }} {{ "HELM" }}

## Accessing Dynamic Information in Templates

- eg. {{- include "my-first-chart.selectorLabels" . | nindent 6 }}
  - look
- eg. {{ .Values.image.pullPolicy }}
  - look in the Values object created from values.yaml image.pullPolicy
- create own custom values to pass in
  - to call values specified in Chart.yaml (the object call must be in CapitalCase for first letter of each word)
  - {{ .Chart.Keywords }} even though Chart.yaml only is using keywords

## Pipe Function in Templates

- eg. {{- include "my-first-chart.selectorLabels" . | nindent 6 }}
  - the output of the left half before | will be pass to the second part as input
- default "some_string" -> set default if empty value pass in (note cannot have : in the "string")
- upper -> move all to cap
- quote -> add quotation ard the string

## Functions in Templates

- nindent someNumber -> newline with indentation by someNumber
- refer to https://helm.sh/docs/chart_template_guide/function_list/ for list of template functions

## Conditional Logic in Templates

- {{- if .Values.customblock.author.enabled }}
- {{"Custom enabled Field is set to true" | nindent 4}}
- {{- else}}
- {{"Custom enabled is set to false" | nindent 4}}
- {{- end }}
  - output from helm template my-first-chart (setting customblock.author.enabled to false in values.yaml)
  - apiVersion: apps/v1
  - kind: Deployment
  - Custom enabled is set to false
- {{- if not .Values.autoscaling.enabled }}
- replicas: {{ .Values.replicaCount }}
  - this means when enabled is set to false -> this condition is true then will use the replicaCount to create the static number of pods
- {{- if and .Values.ingress.className (not (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion)) }}
  - both .Values.ingress.className & the second part are both true
- {{- if or}}
- {{- if ne}}

## TypeCast Values to YAML in Templates

- making array object to yaml format
- {{- with .Values.customblock.author.company }}
- company:
- {{- toYaml . | nindent 4}}
- {{- end}}
  - will print out the array of company stored in values.yaml when running helm template
  - company:
    - MSFT
    - GOOG
    - AMZN
    - TSLA
    - META
- {{- with}}
- {{- else}} (do smth if the object is empty)
- {{- end}}
  - kind: Deployment
  - Empty Array Passed In

## Variable in Templates

- {{ $inplaceVar := true }}
  - kind: Deployment
  - inplace variable is true
- {{ $inplaceVar := .Values.autoscaling.enabled }} -> can read from values.yaml to set the variable value
  - kind: Deployment
  - inplace variable is not set to true

## Loops in Templates

- range iterate over the list (different output from with)
- {{- range .Values.customblock.author.company }}
  - company:
    - -MSFT
  - company:
    - -GOOG
  - company:
    - -AMZN
  - company:
    - -TSLA
  - company:
    - -META
- range can iterate over dictionary/k-v pairs
  - images:
  - {{- range $key,$value := .Values.image}} -> rmb to assign the variable to the range iterator on the .Values.image object
    - {{$key}}: {{$value | quote}}
  - {{- end}}
    - images:
      - pullPolicy: "IfNotPresent"
      - repository: "nginx"
      - tag: ""

## Template Validation

- 3 commands to validate at different levels
  - helm lint (syntax error)
  - helm template (syntax error)
  - helm --dry-run (syntax + compilation error)
- case 1: missing chart name in Chart.yaml (comment out name key-value pair)
  - helm template my-first-chart/
    - Error: validation: chart.metadata.name is required
  - helm lint my-first-chart
    - ==> Linting my-first-chart
    - [ERROR] Chart.yaml: name is required
    - [INFO] Chart.yaml: icon is recommended
    - [ERROR] templates/: validation: chart.metadata.name is required
    - [ERROR] : unable to load chart
    - validation: chart.metadata.name is required
    - Error: 1 chart(s) linted, 1 chart(s) failed
  - helm install test-validation-deployment my-first-chart/ --dry-run
    - Error: INSTALLATION FAILED: validation: chart.metadata.name is required
- case 2: incorrect syntax (missing one curly brace for action in deployment.yaml)
  - helm template my-first-chart/
    - Error: YAML parse error on my-first-chart/templates/deployment.yaml: error converting YAML to JSON: yaml: line 24: did not find expected key
  - helm lint my-first-chart
    - ==> Linting my-first-chart
    - [INFO] Chart.yaml: icon is recommended
    - [ERROR] templates/deployment.yaml: unable to parse YAML: error converting YAML to JSON: yaml: line 24: did not find expected key
    - Error: 1 chart(s) linted, 1 chart(s) failed
  - helm install test-validation-deployment my-first-chart/ --dry-run
    - Error: INSTALLATION FAILED: Kubernetes cluster unreachable:
- case 3: missing apiVersion in deployment.yaml
  - helm template my-first-chart/ (no error during template)
    - kind: Deployment
  - helm lint my-first-chart (no error during linting)
    - ==> Linting my-first-chart
    - [INFO] Chart.yaml: icon is recommended
    - 1 chart(s) linted, 0 chart(s) failed
  - helm install test-validation-deployment my-first-chart/ --dry-run (error during install dryrun)
    - Error: INSTALLATION FAILED: unable to build kubernetes objects from release manifest: error validating "": error validating data: apiVersion not set
      - during dry-run, it is also validating the yaml obj with k8s to check if the obj is deployable or not
- case 4: wrong type passed into key-value pair in values.yaml (not able to catch wrong values using any validation commands)
  - helm template my-first-chart/ (no error during template)
    - kind: Deployment
  - helm lint my-first-chart (no error during linting)
    - ==> Linting my-first-chart
    - [INFO] Chart.yaml: icon is recommended
    - 1 chart(s) linted, 0 chart(s) failed
  - helm install test-validation-deployment my-first-chart/ --dry-run (no error during install dryrun)
    - NAME: test-validation-deployment
    - LAST DEPLOYED: Fri Aug 16
    - NAMESPACE: default
    - STATUS: pending-install
    - REVISION: 1
