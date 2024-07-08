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

# App Config using Posix Lab

## create configMap POSIX

- vim sample-posix-configMap.yml

## apply the configmap

- kubectl apply -f sample-posix-configMap.yml

## create the pod definition

- vim lab-cm-posix-demo-pod.yml

## apply the pod definition

- kubectl apply -f lab-cm-posix-demo-pod.yml

# App Config using File

## Update server

- sudo apt-get update
- apt install apache2-utils

## Create a htpasswd file (user is the username)

- htpasswd -c .htpasswd user
- ls -a (to see the .htpasswd file)
- cat .htpasswd (will see testuser:encryptedPassword)

## Create secrets off the file

- kubectl create secret generic nginx-htpasswd --from-file .htpasswd
- kubectl get secrets
- kubectl describe secret nginx-htpasswd
- rm -rf .htpasswd

## Create configMap off file

- vim nginx.conf
- kubectl create configmap nginx-config-file --from-file nginx.conf
- kubectl describe configmap nginx-config-file

## Create nginx pod

- vim lab-nginx-pod.yml
- kubectl apply -f lab-nginx-pod.yml
- kubectl get pods
- kubectl describe pod nginx-pod
- kubectl logs nginx-pod
