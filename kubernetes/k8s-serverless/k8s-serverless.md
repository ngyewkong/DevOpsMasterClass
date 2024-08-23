# K8s Serverless

## Introduction

- Serverless -> do not require to deploy containers or instances for containers
  - do not need setup infrastructure
  - can be scheduled and invoke when required
- Cloud Providers Serverless Options
  - AWS Lambda
  - Google Cloud Functions
  - Azure Functions
- Underlying Serverless Functions, they are already running on containers behind the scenes
- There is an orchestrator behind the scenes running the serverless functions
- Serverless on public cloud reduce the complexity, operational cost, infrastructure setup effort
- no need to manage OS distribution, no need to build containers
- pay less only the time the function is running
- Popular Serverless Frameworks & Projects:
  - Fission (work with AWS & GCP)
  - Kubeless (specifically desgined for native serverless application)
  - OpenWhisk
  - OpenFaaS
- Users need to install these projects on k8s clusters to use the Serverless Functions
- Admin will still need to manage the k8s infrastructure

## Kubeless (Serverless Project on k8s)

- K8s-native serverless framework that let you deploy small bits of code (functions) without having to worry about infrastructure
- kubeless is deployed on top of a k8s cluster
- kubeless enables functions to be deployed on a k8s cluster while allowing users to leverage k8s resources to provide auto-scaling, API routing, monitoring & troubleshooting
- anything that triggers a kubeless function to execute is regarded by the framework as an Event
- open-source & free for use
- also have UI available for developer to deploy functions
- support all major languages:
  - python
  - ruby
  - nodejs
  - php
  - golang
- kubeless cli is compliant with aws lambda cli
- when function is deployed -> user need to find out how to trigger these functions
- trigger mechanisms:
  - pubsub triggered (kafka, NATS)
  - http triggered (exposed as k8s services)
  - schedule triggered (cron jobs)

## Kubeless Installation & Deploy Functions Demo (NOT WORKING FOR K8S >v1.18)

- check k8s cluster health state (must be healthy for kubeless)
  - kops validate cluster (for non minikube clusters) / minikube status (minikube clusters)
- check if RBAC is enabled or not (need to enable on the cluster)
  - kubectl api-versions (check for rbac.authorization.k8s.io)
- install kubeless on the cluster
  - download kubeless release
    - curl https://github.com/vmware-archive/kubeless/releases/download/v1.0.8/kubeless_darwin-amd64.zip
    - unzip kubeless_darwin-amd64
    - sudo mv bundles/kubeless_darwin-amd64/kubeless /usr/local/bin
  - create kubeless namespace
    - kubectl create ns kubeless
  - create a function CRD & launch a controller (follow the updated manifest to use rbac v1 instead of v1beta1)
    - kubectl create -f kubeless-v1.0.8.yaml
