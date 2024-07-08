# Shared Volume Lab

## On Master Node

- vim shared-vol.yml
- kubectl apply -f shared-vol.yml
- kubectl get pods -o wide
- kubectl describe pod shared-multi-container
  - nginx-container: Mounts: /usr/share/nginx/html from html (rw)
  - debian-container: Mounts: /html from html (rw)
- curl the pod ip address
  - should see the dates being returned
  - as both containers are sharing the emptyDir
    - both reading and writing the same file
- kubectl exec -it shared-multi-container -- bash
- cd /usr/share/nginx/html/
- cat index.html
  - Mon Jul 8 14:44:52 UTC 2024
  - Mon Jul 8 14:44:57 UTC 2024
- edit the index.html
  - echo "Test Shared Volume" >> index.html
- exit
- curl the ip address again
  - should see the updated index.html with the echo text
