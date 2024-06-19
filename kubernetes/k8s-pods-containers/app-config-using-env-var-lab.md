# App Config using Env Variables Lab

## Create ConfigMap Object

- vim sample-configMap.yml
- kubectl apply -f sample-configMap.yml
- kubectl get cm

## Describe ConfigMap

- kubectl describe cm lab-demo-cm

## Create Secrets Object

- vim sample-secret.yml
- echo -n "credentialValue" | base64
- replace the value in sample-secret.yml with the encoded base64 version
- kubectl apply -f sample-secret.yml
- kubectl get secrets
- kubectl describe secret lab-demo-secret (data is not shown)
- rm the yml files containing the credentials

## pass ConfigMap to Container as Env Variable

- create a pod definition
  - vim lab-cm-env-demo-pod.yml
- kubectl apply -f lab-cm-env-demo-pod.yml
- kubectl get pods
- kubectl exec lab-cm-env-demo -it -- sh
- verify the shell env of the running pod have the env var
  - echo $PROPERTIES_FILE_NAME
  - printenv (to show the full list of env var)

# App Config using Mount Volumes Lab

## create configMap & secrets (same as env)

- vim sample-configMap.yml
- kubectl apply -f sample-configMap.yml
- kubectl get cm
- kubectl describe cm lab-demo-cm
- vim sample-secret.yml
- echo -n "credentialValue" | base64
- replace the value in sample-secret.yml with the encoded base64 version
- kubectl apply -f sample-secret.yml
- kubectl get secrets
- kubectl describe secret lab-demo-secret (data is not shown)
- rm the yml files containing the credentials

## pass configMap as mount volumes to containers

- create pod definition
  - vim lab-cm-vol-demo-pod.yml
- kubectl apply -f lab-cm-vol-demo-pod.yml
- kubectl get pods
- kubectl exec lab-cm-vol-demo -it -- sh
- the configmap key:value pairs and secrets are located in the mount path
  - ls /etc/config/configMap/
  - ls /etc/config/secret