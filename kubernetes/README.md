# Kubernetes

## Introduction

- k8s - Orchestration Tool
- manage state of containers
  - start containers on specific nodes
  - restart containers when it get killed
  - move containers from one node to another
- features:
  - automated scheduling: k8s provides adv scheduler to launch container on cluster nodes based on their resource requirements & other constraints
  - healing capabilities: k8s will replace and reschedule containers when nodes die, k8s do not allow containers to use until they get ready
  - auto upgrade & rollback: k8s roll out changes to its app or configuration, monitoring app ensure k8s do not kill all instance, if smth go wrong, can rollback the change
  - horizontal scaling: k8s can scale up & down the app as per requirements with a simple command or ui or based on CPU usage automatically
  - storage orchestration: k8s can mount the storage sys of user choice, can opt for either local storage or public cloud provider
  - secret & config management: k8s can help to deploy & update secrets & app config without rebuilding the app image & without exposing secrets in the stack configuration
- k8s can be ran:

  - On-Premise (own DC)
  - Public Cloud (AWS, GCP, Azure, Digital Ocean)
  - Hybrid Cloud

## Architecture

- k8s follows Master-Slave Architecture
- Master Node: Responsible for mgmt of k8s cluster, Entrypoint for all admin tasks
  - can have multi-master nodes
- Workflow: CLI/APIs/UI req -> Master Node/s -> Worker Nodes
  - Master Node: Control Plane components consist controller, api-server, scheduler, etcd
    - kube-api-server: Entrypoint for all REST commands used to control the cluster, only interaction point with k8s
    - etcd: Distributed key-value-store which stores the cluster state, used as backend service for k8s, provides HA of data related to cluster state (impt to externalise the etcd in the event of master node failure)
    - kube-scheduler: Regulate the tasks on slave nodes, store resource usage information for each slave node
    - kube-controller: Runs multiple controller utility in a single process, carry automated tasks in k8s cluster
      - kube-control-manager
  - Worker Node: kube-proxy, kublet & pods
    - kublet: k8s agent executed on worker nodes, gets config of a pod from the api-server from master node and ensures the described containers are up & running
    - pods: group of one or more containers with shared storage/network & spec for how to run the containers
      - share the same shared content and IP but reach other pods via localhost
      - single pod can run on multiple machines and single machine can run multiple pods
    - kube-proxy: runs on each node to deal with individual host sub-netting and ensure that the services are available to external parties

## Installation

- HA deployment (1 Master 2 Slaves)

  - setup using kubeadm

    - ssh into master node
      - follow doc https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
      - sudo apt-get update
      - sudo apt-get install -y apt-transport-https ca-certificates curl gpg
      - curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      - echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
      - sudo apt-get update
      - sudo apt-get install -y kubelet kubeadm kubectl
      - sudo apt-mark hold kubelet kubeadm kubectl
      - cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
      - overlay
      - br_netfilter
      - EOF
      - sudo modprobe overlay
      - sudo modprobe br_netfilter
      - cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
      - net.bridge.bridge-nf-call-iptables = 1
      - net.ipv4.ip_forward = 1
      - net.bridge.bridge-nf-call-ip6tables = 1
      - EOF
      - sudo sysctl --system
      - sudo apt-get update && sudo apt-get install -y containerd
      - sudo mkdir -p /etc/containerd
      - containerd config default | sudo tee /etc/containerd/config.toml
      - sudo systemctl restart containerd
      - sudo systemctl status containerd
    - initialize k8s control plane (with an IP range)
      - kubeadm init --pod-network-cidr=192.168.0.0/16
    - setup kubeconfig on the machine (regular user)
      - mkdir -p $HOME/.kube
      - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      - sudo chown \$(id -u):\$(id -g) $HOME/.kube/config
    - setup kubeconfig on the machine (root user)
      - export KUBECONFIG=/etc/kubernetes/admin.conf
    - deploy pod network
      - kubectl apply -f podnetwork.yaml (refer to https://kubernetes.io/docs/concepts/cluster-administration/addons/)
      - kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml (using calico)
      - kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml
      - watch kubectl get pods -n calico-system (check if calico is up)
      - kubectl get pods --all-namespaces
      - kubectl get nodes -o wide
    - to get the join token for worker node
      - kubeadm token create --print-join-command
      - kubeadm token list (get list of generated tokens)
    - install kubeadm on worker nodes (follow above installation steps used in master node)
    - join worker nodes to cluster using kubeadm (ssh into worker nodes and execute)
      - kubeadm join MasterNodeIP:6443 --token someautogentoken --discovery-token-ca-cert-hash sha256:someSHA

- Single Node deployment (MiniKube k8s cluster)
  - Install Docker (Follow the docker docs)
  - Install kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
    - curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    - sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    - kubectl version --client
  - Install MiniKube
    - wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    - sudo cp minikube-linux-amd64 /usr/local/bin/minikube
    - sudo chmod +x /usr/local/bin/minikube
    - minikube version
    - sudo apt install conntrack
    - minikube start --force (on digital ocean)
    - kubectl is now configured to use "minikube" cluster and "default" namespace by default
    - minikube status
    - kubectl config view (view the certificate, namespace, user, context)
  - Install Fish (optional) (terminal interactive ui)
    - sudo apt install fish
    - fish (to use it in the current cli window)

## Useful CLI Commands

- kubectl create deployment deploymentName --image=imageName
  - kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.10
- kubectl get deployment
- kubectl get pods -A
- expose container to external (need to create a k8s service which create the access point)
  - kubectl expose deployment deploymentName --type=ServiceType --port=ListeningPodPort
  - kubectl expose deployment hello-node --type=LoadBalancer --port=8080
- kubectl get services
- minikube service hello-node / minikube service list
  - NAMESPACE | NAME | TARGET PORT | URL
  - default | hello-node | 8080 | http://192.168.49.2:32024
- kubectl delete service hello-node
- kubectl delete deployment hello-node

## Namespaces

- Namespaces are virtual cluster backed by the same physical cluster
- k8s objects (pods & containers) live in namespace
- Namespaces are used to separate & organise obj in k8s
- list all the namespaces
  - kubectl get namespaces
- All clusters have default namespace
- specify namespace to resources (--namespace or -n flag)
  - kubectl get pods --namespace NAMESPACE (this will return pods in the specified namespace)
  - kubectl get pods (this will return all pods in default namespace)
  - kubectl get pods --all-namespaces (this will all pods in all namespaces)
- can use namespaces as a logical bind or organisation
- create namespace in k8s
  - kubectl create namespace NAMESPACE
    - kubectl create namespace dev
- kubeadm (cluster setup tool for following best practices k8s cluster creation)
  - --config to pass a custom config file

## Cluster Management

- App HA in k8s cluster
  - Infra HA
  - Cluster HA
    - Need MULTIPLE Control Planes (Master Nodes)
    - Need Load Balancer to communicate among multiple control planes & worker nodes will also comm to the load balancer
    - Stacked etcd (more popular model)
      - each master node has their own etcd server
    - External etcd
      - each master node control plane only have the kube-api-server & other components
      - setup another node or another cluster for etcd server

## K8s Management Tools

- kubectl
  - official k8s cli
  - the other way is the rest api
- kubeadm
  - used to create k8s cluster
- minikube
  - k8s dev tool
  - help to setup k8s cluster in a single node quickly for dev work
- helm
  - k8s template and package mgmt tool
  - ability to convert k8s objects into reusable templates
  - ability to provide complex multi-config templates with cross connectivity (interdependency)
- kompose
  - tranlates docker compose files into k8s object
  - ability to ship docker containers to k8s
- kustomize
  - configuration mgmt tool for k8s obj config
  - similar to helm
  - ability to create reusable templates for k8s

## Maintenance Windows in K8s

- remove node from cluster

  - node draining
    - removing a node from cluster in service
    - app shld not be impacted by this process (no downtime)
    - containers running on that node will be gracefully shutdown and rescheduled to another available node
    - use kubectl to drain a node
      - kubectl drain nodeName
  - ignore daemon sets (if DaemonSet (pods that are tied to eeach node) is running in k8s cluster)
    - when there are requirements to execute particular process on eg. all worker nodes (monitoring process on worker)
      - kubectl drain nodeName --ignore-daemonsets
    - pods that are executed on this drained node will not be rescheduled on another available node
    - deployment that are excuted on multiple nodes will be rescheduled on availble node (i.e k8s-worker-03)
  - uncordoning a node (after upgrade/patch)
    - if node is still part of the cluster & want to allow pods on that particular node
    - basically allowing master node to schedule the additional resources in that particular node
      - kubectl uncordon nodeName
    - does not guarantee that existing rescheduled pods will execute again on the uncordoned node
    - workaround is to drain the other worker node and uncordon the other worker node

## Upgrade K8s Cluster (to sync the cluster with latest k8s release)

- upgrade with kubeadm
- master node (control plane) upgrade
  - drain the control plane node
  - plan the upgrade using kubeadm upgrade plan command
  - apply the plan
  - upgrade kubectl & kubelet on control plane node
- worker node upgrade (do not need to create plan and apply plan for worker node)
  - drain the node
  - upgrade kubeadm
  - upgrade kubelet config
  - upgrade kubectl & kubelet

## K8s Object Management (kubectl)

- kubectl is the command line tool for k8s
- internally use k8s rest api to carryout the commands
- to get objects present in the k8s cluster
  - kubectl get object_type object_name -o output_filename --sort-by JSONpath --selector selectorName
- to get detailed info abt the k8s object
  - kubectl describe object_type object_name
- create any k8s object (if referencing a file, the file needs to be in yaml)
  - kubectl create -f file_name.yaml
- similar to create but allow overriding of existing objects (create will fail on existing objects)
  - kubectl apply -f file_name.yaml
- delete k8s object from the cluster
  - kubectl delete object_type object_name
- to execute any commands inside the running container
  - kubectl exec pod_name -c container_name

## K8s RBAC (Role-Based Access Management)

- admin access is too much access for most use cases
- RBAC Objects in k8s (deine set of permissions eg. read/write access)
  - ClusterRoles (define permission across the cluster. not limited to specific namespace scope)
  - ClusterBinding (Obj connects ClusterRoles to Users)
  - Roles (define permission within namespace)
  - RileBinding (Obj connects Roles to user)
  - Binding is many-to-many relationships

## ServiceAccounts in K8s Cluster

- ServiceAccount is used by container process to authenticate with k8s apis
- eg. monitoring tool that need to interact with k8s apis, will need to create ServiceAccount on those pods for access
- If pods need to communicate with k8s apis, user need to setup ServiceAccount to control the access
- can be created using yaml manifest file
  - namespace field is optional (specify namespace -> scoped to namespace level if not cluster level)
- will need Binding (RoleBinding/ClusterRoleBinding)
  - ServiceAccount access is also managed by RBAC
  - Bind ServiceAccounts with ClusterRole or ClusterRoleBinding to provide access to Cluster APIs
  - in the manifest, set kind RoleBinding or ClusterRoleBinding, set a ServiceAccount kind under "subjects" field

## Pods & Containers in K8s

- Application Config
  - properties or settings that are externalised eg. db configuration
  - k8s allows user to pass dynamic config values to app during runtime
  - allow user to control the app flow
  - eg config for dev/uat/prod
  - can pass the config via ConfigMap in k8s
- ConfigMaps
  - keep non-sensitive data in configMap (no secrets/credentials) to pass to container running application
  - store in key-value format
  - allow users to separate configurations from pods and components
    - multiple configMaps for multi containers (separate config for pod to pod, 1:1 mapping for container to configMap)
  - make configuration easier to change and manage
  - prevent hardcoding of config data to pod
  - configMap Commands
    - via config file (can be multiple files to create a single configMap)
      - kubectl create configmap nameOfConfigMap --from-file filePath1 --from-file filePath2
      - kubectl create condifmap nameOfConfigMap --from-file directoryPath
    - via cli (to get existing configmap alr running on sys)
      - kubectl get configmap nameOfConfigMap -o yaml (yaml output file)
      - kubectl get configmap nameOfConfigMap -o json (json output file)
- Secrets
  - designed to keep sensitive data
  - can create secrets from file (after generate secrets can delete the files)
    - kubectl create scret secretName --from-file=./fileName.txt --from-file=./fileName2.txt
  - get from cli
    - kubectl get secrets (default namespace)
    - kubectl describe screts secretName
  - secrets.yaml file for username & password need to be in encoded64 format
  - take note for special characters used in secrets such as "$", "\", "\*", "\!" require escaping
- Env Variables
  - Pass ConfigMap and Secrets to Containers via Env Var
    - using valueFrom: configMapKeyRef: to set the env variable to ref the configMap
- Configuration Mount Volumes
  - Pass Config Data and Secrets to Containers
  - Config Data will be available in Files to Container system
    - using volumes: -name: config-volume configMap:
- Container Resources
  - Resource Request
    - allows user to define a resource limit that container is expected to use
    - kube scheduler will manage resource req and avoid scheduling on node which do not have enough resources
    - Note: containers are allowed to use more or less than the request resource
    - Note: Resource Request is to manage the scheduling of resources only
    - Memory is measured in Bytes or MB
    - CPU resources are measured in cpu units. 1 vCPU -> 1000 CPU unit, 500 CPU units is half core cpu
    - set in the pod definition under containers: resources: requests: memory: "64Mi" cpu: "250m" -> 64MB mem, 0.25 core cpu
  - Resource Limit
    - the actual limit the container resource can use
    - limits are imposed at RunTime container
    - set in the pod definition under containers (instead of requests -> limits): resources: limits: memory: "128Mi" cpu: "500m" -> maximum use 128Mb and 0.5 cpu core
    - once hit the memory limit, k8s will kill the container & restart the container
    - once hit the cpu limit, k8s will throttle the process but container still running
- Container Health Check
  - k8s provide features to monitor containers
  - active monitoring helps k8s decide the container state and auto restart failed container
    - minimise downtime
  - Liveness Probe (active health check - check if container is running)
    - helps to determine the container state
    - by default, k8s only consider container to be down if container process is stopped
    - helps user to improve & customised the container monitoring mechanism
    - two types of liveness probes
      - Run Command in Container (initialDelay is set to not check immediately give the container to startup)
        - livenessProbe: exec: command: -the-command-to-run- initialDelaySeconds: 5 periodSeconds: 5
      - Periodic HTTP Health Check (for web app, timeoutSeconds is how long the req can take before being marked as failure)
        - livenessProbe: httpGet: path: somepath/health.html port:8080 httpHeaders: -name: Custom-Header value: awesome initialDelaySeconds: 3 periodSeconds: 3 timeoutSeconds: 1
  - Startup Probe
    - setting up liveness probe is tricky with app that has long startup time eg. data analytics app, heavy software > 10mins 50mins etc
    - only runs at container startup and stop running once container success
    - if both startup & liveness probes are in the manifest -> startup probe will execute first during container startup then starup probe will exit and liveness probe will take over
    - parameters are same as liveness probe setup manifest
      - failureThreshold: when startup probe fails, k8s will retry x number of times before giving up
      - if both failure Threshold and periodSeconds are set, the app will have failureThreshold x periodSeconds to finish its startup
  - Readiness Probe
    - used to detect if container is ready to accept traffic
      - eg app is backend and frontend (2 containers)
      - frontend container usually launch and ready very quickly compared to backend
      - backend container might not come up yet
      - frontend container starts accept traffic -> error as backend is still down
      - eg need to load large data or config files during startup
      - eg depends on external services after startup
    - define end-to-end health checks
    - no traffic will be sent to the pod until container pass readiness probe
    - readinessProbe (fields are same as liveness/startup probes): exec: command: - cat - /tmp/healthy initialDealySeconds: 5 periodSeconds: 5
    - liveness and readiness probes can be set in the same manifest to ensure end to end and container running state
- Pods Restart Policies
  - By default, it is set to Always in k8s
  - Always Policy
    - containers will always restart even if container completed successfully
    - eg. one time executable job that you only want to run once and exit
    - Always policy is recommended for containers that should always be in running state
    - intermittent containers shld not have this Always Policy
  - OnFailure Policy
    - if container process exit with error code -> pod restarts
    - works with liveness probe to determine if container is healthy
    - use this policy on app that needs to be run successfully & then stop (will not restart in stopped state)
  - Never Policy
    - never allow container to restart even if liveness probe failed
    - use this policy on app that run only once and never automatically restarted
- Multi-container Pods
  - k8s pods can have single or multiple containers in a pod
  - multi-container pods, containers can share the resources like network & storage
  - containers in multi-container pods can also communicate on localhost
  - note: best practice is to keep containers in separate pods unless we want the containers to share the resources
  - containers can interact with shared resources in the same pod
    - Network: containers share the same network and communicate on any port unless the port is exposed to cluster
    - Storage: containers can use the same shared volumes & share data
- Container Initialization
  - Init Containers
    - specialized containers that run before app containers in a Pod
    - only run once during the start up process of Pod
    - can contain utilities or setup scripts not present in an app image
    - Users can define N number of Init Containers in a Pod Manifest file
    - Flow: Init Container 1 -> Init Container 2 (sequential) -> App Container (will only start once all Init Containers completed status)
    - Use Case: Setup App Init or Setup Scripts
      - make app image less bulky
    - Init containers offer a mechanism to block or delay app container startup until a set of preconditions are met
    - Init containers can securely run utilities or custom code that would otherwise make an app container image less secure
    - Populate data at Shared Volume before app startup

## Pods Allocation in K8s

- force delete pods in K8s
  - kubectl delete all --all --force -n namespace
- Pods Scheduling
  - scheduling is a process to assign pods to nodes so that kubectl can run them
  - Scheduler: component on k8s master node/control plane which decides the pods assignment on nodes
    - factors affecting pod assignment
      - resource request vs available node resources
      - configuration like node labels
      - nodeSelector, Affinity & Anti-Affinity
        - nodeSelector
          - defined in pod spec to limit which node the pod can be scheduled on (label)
          - use labels to select the suitable node (nodeSelector: disktype: ssd -> the pod will only be scheduled on a node that has disktype: ssd as its label)
        - nodeName
          - bypass scheduling & assign pod to a specific node using node name
          - not a good option for pod scheduling due to its limitations (dynamic infra -> no pod will be scheduled if the nodeName does not match)
- DaemonSets
  - k8s Object that run a copy of a node on each node
  - runs a copy of a pod on a new node as they are added to the cluster
  - helpful use case for monitoring, log collection, proxy configuration etc
  - default attached restart policy for a DaemonSet obj is "Always" restart policy
- DaemonSets Scheduling (similar to Pods scheduling)
  - follows normal scheduling rules around node labels, taints & tolerations
  - if pods normally not scheduled on a node, daemonset will also not create copy of pod on that node
- Static Pods
  - directly managed by kubelet on k8s nodes
  - not managed by the control plane
  - K8s API Server not required for Static Pods
  - kubelet watches each Static Pod (restarts it if it fails)
  - kubelet autonatically creates Static Pods from the manifest yaml file located at the specific manifest path on each node
    - will be similar to pod spec manifest yaml file
  - Use Case: monitoring or configuration without any K8s API server
- Mirror Pods
  - A Mirror Pod represents a Static Pod in the Kuberntes API, allowing you to easily view the Static Pod's status.
    - replicas of the static pod
  - kubelet will create the mirror pod for each static pod
  - mirror pods allow user to monitor static pods via K8s API Server or Control Plane
  - can view status of static pods via mirror pods
  - but cannot change or update static pods via mirror pods
    - for change, will need to update the manifest yaml file on the node and kubelet will update the status
- Node Affinity in K8s
  - enhanced version of NodeSelector
  - used for Pods Allocation on Worker Nodes
  - operator: In
  - Not to schedule pod on specific node can be done via Node Anti-Affinity
    - opposite of Node Affinity & NodeSelector concept
  - requiredDuringSchedulingIgnoredDuringExecution:
    - condition must be fulfilled at time of Pod Creation
    - known as Hard Affinity
    - pod will still run if labels on a node change and affinity rules are no longer met
  - preferredDuringSchedulingIgnoredDuringExecution:
    - prefer node to fulfill the condition but not mandatory
    - known as Soft Affinity
  - requiredDuringSchedulingRequiredDuringExecution:
    - must be matched during scheduling & during execution of the pods
- Node Anti-Affinity in K8s
  - similar syntax definition in yaml files as Node Affinity
  - key difference:
    - operator: NotIn
    - force pod to not be scheduled on node that meets the criteria
- Preferred way is to use Node Affinity or Node Anti-Affinity over Node Selector over Node Name
  - more flexibility
  - nodeAffinity > nodeSelector > nodeName

## K8s Deployments

- Scaling Application in K8s -> allow handling of more requests per minute (rpm)
- pods can be scaled vertically (increase resources to existing nodes) or horizontally (increase number of nodes)
- Stateless App
  - stateless app do not save client data generated in one sessiion for use in the next session with that client
  - stateless app can be scaled horizontally (no intermediate data)
  - new pods can be created for stateless apps
  - eg frontend app
- Stateful App
  - stateful app saves client data from activities for use in next session
  - data saved is called the app state
  - stateful app can be scaled vertically
  - eg database service
  - db services cannot be split in multiple instances
- ReplicationController
  - used to manage app instances scaling
  - ensures that a specified number of pod replicas are running at any point of time
  - ensures pod or set of pods are always up & available according to spec specified
- ReplicaSet
  - enhanced version of ReplicationController
  - like ReplicationController maintains the set of replica pods running at any given time
  - main difference is the selector support
    - ReplicaSet allows for matchExpressions which we can provide conditional statement
      - In, NotIn, Exists operators etc
  - Label Selector used to identify a set of Objects in k8s
  - can use "set-based" label selector
- Bare Pods
  - Bare Pods do not have labels which match the selector of one of your ReplicaSets
  - must make sense the labels do not match with the condition set in the ReplicaSet template
    - ReplicaSet is not limited to its own created Pods specified by its template
    - it will acquire other Pods which have matching labels
- Deployment Object
  - One step higher than ReplicaSet
  - top level abstract hierarchy
  - desired state of ReplicaSet
  - Deployment control both ReplicaSets & Pods in a declarative manner
  - Smallest Unit of Deployment is a Pod which runs containers
    - Each pod has its own IP address & shares a PID namespace, network & hostname
  - Deployment -> ReplicaSet -> Pod -> Container
  - Use Case for Deployment
    - Create Deployment: Deploy Application Pods
    - Update Deployment: Push new version of App in controlled manner
    - Rolling Upgrade: Upgrade App with zero downtime (one pod at a time)
    - Rollback: rollback the upgrade in case of unstable upgrade, revise the deployment state (rolling restart/rollback)
    - Pause/Resume Deployment: Rollout a certain percentage
