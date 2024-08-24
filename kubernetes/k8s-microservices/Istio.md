# Istio

## Introduction to Istio

- microservice pattern
  - client -> ingress network -> route to different pods (services)
- challenge with microservices in k8s:
  - no encryption of data communication microservice to microservice
  - no load balancing
  - no failover or auto-retries
  - no routing decision (related to load balancing)
  - no load metrics/logs happening in the microservice
  - no access control to services in k8s cluster
- need to use a proxy to achieve these features -> Istio service mesh
- Istio service mesh provides several capabilities to services
  - traffic monitoring
  - access control
  - discovery
  - security
  - resiliency
- Istio deployed in k8s for micro services without any change in codebase for microservice
- Underlying Istio deploys an Istio proxy (Istio Sidecar) next to each service
- All of traffic is directed to the proxy which use policies to decide how, when or if that traffic should be redirected to the service
- in each service, there will be an Istio envoy container in the service pod which handles HTTP, gRPC, TCP w/wo TLS protocols
- in the upper layer -> control plane REST API layer it will have a Pilot, Mixer, Istio-Auth (Envoys are all connected to these 3 components)
  - Pilot: handles traffic redirection
  - Mixer: all the policy checks & telemetry is being handled by the Mixer
  - Istio-Auth: manage all the certificate that is required to manage the proxies
