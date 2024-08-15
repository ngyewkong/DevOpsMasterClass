# HELM Templates Syntax

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
