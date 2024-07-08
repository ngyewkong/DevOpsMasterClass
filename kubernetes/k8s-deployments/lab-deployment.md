# Deployment Lab

## On Master Node

### Part 1: Create Deployment

- vim deployment.yml
- kubectl apply -f deployment.yml
- kubectl get pods --show-labels
- kubectl get deployment.apps/chef-server
- kubectl rollout status deployment.apps/chef-server
  - deployment "chef-server" successfully rolled out
- kubectl describe deployment.apps/chef-server
  - StrategyType: RollingUpdate
  - RollingUpdateStrategy: 25% max unavailable, 25% max surge
  - Normal ScalingReplicaSet 2m8s deployment-controller Scaled up replica set chef-server-6d6d4cb885 to 3
- kubectl get rs
  - chef-server-6d6d4cb885 3 3 3 6m6s
- even though ReplicaSet is not specified in the manifest
- ReplicaSet is a sub tier of Deployment object (being created by Deployment)

### Part 2: Rolling Upgrade

- from app image v1.1 to v1.2
- Initial: 3 Pods are all on 1.1
- Upgrade: 3 more Pods are created on v1.2 image
- bring down 1 pod on 1.1 -> 2 pods on 1.1 1 pod on 1.2 (traffic still not affected)
- traffic not impacted (rolling upgrade)
- kubectl set image deployment/deploymentName containerName=newAppImagename
  - kubectl set image deployment/chef-server ubuntu=ubuntu:20.04
  - deployment.apps/chef-server image updated
- kubectl rollout status deployment/chef-server
  - Waiting for deployment "chef-server" rollout to finish: 1 old replicas are pending termination...
  - deployment "chef-server" successfully rolled out
- kubectl get pods --show-labels
- kubectl rollout history deployment/chef-server (can see the revisions)
- kubectl set image deployment/chef-server ubuntu=ubuntu:22.04 --record
  - --record flag will keep the record of this change and reflect in rollout history
- kubectl rollout status deployment/chef-server
- kubectl rollout history deployment/chef-server
  - deployment.apps/chef-server
  - REVISION CHANGE-CAUSE
  - 1 <none>
  - 2 <none>
  - 3 kubectl set image deployment/chef-server ubuntu=ubuntu:22.04 --record=true
- kubectl describe pod chef-server-7c588c44f4-rfh29
  - ubuntu:
  - Image: ubuntu:22.04 (ubuntu container in pod is successfully updated to 22.04 image)

### Part 3: Rollback

- kubectl rollout undo deployment/chef-server
  - deployment.apps/chef-server rolled back
- kubectl rollout history deployment/chef-server
  - deployment.apps/chef-server
  - REVISION CHANGE-CAUSE
  - 1 <none>
  - 3 kubectl set image deployment/chef-server ubuntu=ubuntu:22.04 --record=true
  - 4 <none>
  - rollback to revision 2 which is now revision 4
- kubectl describe pod chef-server-574b67f4dd-fcrq6
  - ubuntu:
  - Image: ubuntu:20.04 (ubuntu container in pod rollback to 20.04 from 22.04 image)
- rollback to specific revison
  - kubectl rollout undo deployment.apps/chef-server --to-revision=1
  - kubectl rollout status deployment/chef-server
  - kubectl rollout history deployment/chef-server
- kubectl describe pod chef-server-6d6d4cb885-ldkrv

  - ubuntu:
  - Image: ubuntu:18.04 (ubuntu container in pod rollback to revision 1 using 18.04 image)

- Another way to update the image (Not recommended as there is no way to add the record of the change in the revision using edit)
  - kubectl edit deployment/chef-server (and edit the file to 24.04)
    - deployment.apps/chef-server edited
  - kubectl rollout status deployment/chef-server
  - kubectl describe deployment/chef-server
    - ubuntu:
    - Image: ubuntu:24.04

### Part 4: Pause & Resume (for bulk changes to update together)

- kubectl rollout pause deployment/chef-server
  - deployment.apps/chef-server paused
- kubectl set image deployment/chef-server ubuntu=ubuntu:23.10 --record
  - deployment.apps/chef-server image updated
- kubectl rollout status deployment/chef-server
  - Waiting for deployment "chef-server" rollout to finish: 0 out of 3 new replicas have been updated...
- kubectl set resources deployment/chef-server -c=chef-server --limits=memory=250Mi
  - deployment.apps/chef-server resource requirements updated
- kubectl rollout status deployment/chef-server
  - Waiting for deployment "chef-server" rollout to finish: 0 out of 3 new replicas have been updated...
- to put all the changes in effect -> resume deployment
  - kubectl rollout resume deployment/chef-server
    - deployment.apps/chef-server resumed
- kubectl rollout status deployment/chef-server
  - Waiting for deployment "chef-server" rollout to finish: 1 out of 3 new replicas have been updated...
  - Waiting for deployment "chef-server" rollout to finish: 1 out of 3 new replicas have been updated...
  - Waiting for deployment "chef-server" rollout to finish: 1 out of 3 new replicas have been updated...
  - Waiting for deployment "chef-server" rollout to finish: 2 out of 3 new replicas have been updated...
  - Waiting for deployment "chef-server" rollout to finish: 2 out of 3 new replicas have been updated...
  - Waiting for deployment "chef-server" rollout to finish: 2 out of 3 new replicas have been updated...
  - Waiting for deployment "chef-server" rollout to finish: 1 old replicas are pending termination...
  - Waiting for deployment "chef-server" rollout to finish: 1 old replicas are pending termination...
  - deployment "chef-server" successfully rolled out
- kubectl describe deployment/chef-server
  - chef-server:
    - Limits:
    - memory: 250Mi
  - ubuntu:
    - Image: ubuntu:23.10
- kubectl rollout history deployment/chef-server

### Part 5: Scaling Deployment

- kubectl scale deployment/chef-server --replicas=5
- kubectl rollout status deployment/chef-server
- kubectl get pods --show-labels (see 5 pods being created)
