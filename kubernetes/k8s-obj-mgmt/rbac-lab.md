# RBAC in K8s Lab

## Add User in k8s cluster

1. Create namespace

- kubectl create ns development

2. Create private key & CSR (Cert Signing Req) for "DevUser"

- cd ${HOME}/.kube
- sudo openssl genrsa -out DevUser.key 2048
- sudo openssl req -new -key DevUser.key -out DevUser.csr -subj "/CN=DevUser/O=development"
  - CN -> common name field will be used as username for the auth req
  - O -> organisation field will be used to indicate group membership of the user

3. Provide CA keys of k8s cluster to gen the cert

- sudo openssl x509 -req -in DevUser.csr -CA ${HOME}/.minikube/ca.crt -CAkey ${HOME}/.minikube/ca.key -CAcreateserial -out DevUser.crt -days 45

4. Get k8s cluster config

- kubectl config view (current context is minikube, user is minikube)

5. Add User to kubeconfig file

- kubectl config set-credentials DevUser --client-certificate ${HOME}/.kube/DevUser.crt --client-key ${HOME}/.kube/DevUser.key

6. Get k8s cluster config

- kubectl config view (DevUser is added in the kubeconfig -> 2 users: minikube & DevUser)

7. Add a context to the config file -> this will allow this user "DevUser" to access the development namespace in the cluster

- --cluster=CLUSTER_NAME (for HA k8s deployments)
- kubectl config set-context DevUser-context --cluster=minikube --namespace=development --user=DevUser

8. Get k8s cluster config

- kubectl config view (new context "DevUser-context" set in minkube cluster, development namespace, user DevUser)

## Create A role for DevUser

1. Test access by list pods (did not mention namespace as the context is alr configured with namespace development)

- kubectl get pods --context=DevUser-context
- Error Forbidden as DevUser do not have any permission to access pods

2. Create a Role Resource using a yaml manifest file

- vim pod-reader-role.yaml

3. Create the Role

- kubectl apply -f pod-reader-role.yaml

4. Verify Role

- kubectl get roles -n development
- will get the pod-reader role created from the manifest file

5. Add Role to User

- Create RoleBinding spec file
  - vim pod-reader-rolebinding.yaml
- Create RoleBinding
  - kubectl apply -f pod-reader-rolebinding.yaml
- Verify RoleBinding is created
  - kubectl get rolebinding -n development

6. Verify User is able to access pods

- kubectl get po --context=DevUser-context

7. Create Pod in development namespace (will error as DevUser do not have the create access)

- kubectl run nginx --image=nginx --context=DevUser-context
- Create the pod using root
  - kubectl run nginx --image=nginx -n development
- Verify there is pod running in development namespace
  - kubectl get po --context=DevUser-context
