# Assignment - Docker Swarm Multi Node Deployment

- Docker's Distributed Voting App
- Python, Node.js, .NET, redis
- refer to dockersamples/example-voting-app for the docker compose/swarm file https://github.com/dockersamples/example-voting-app
- Service need 1 Mount Volume, 2 Network & 5 Stack Services
- 2 Overlay Networks (frontend & backend)

- Services Required (5):
  - Voting App (Web frontend app):
    - Image: dockersamples/examplevotingapp_vote
    - Publish port on 5000, container port listen on 80
    - Publish 4 replicas
    - use frontend overlay network
  - Redis (Collect new votes):
    - Image: redis:alpine
    - Publish 4 replicas
    - use frontend overlay network
  - Worker (.NET service that consumes votes and stores them to DB):
    - Image: dockersamples/examplevotingapp_worker
    - Publish 4 replicas
    - Use both frontend & backend overlay networks
  - DB:
    - Image: postgres:15-alpine
    - Mount Volume and mount to /var/lib/postgresql/data
    - Publish on backend overlay network
    - Publish 1 replica
  - Result Service (to display the voting result):
    - Image: dockersamples/examplevotingapp_result
    - Publish on backend overlay network
    - Publish on port 5001, container listen on port 80
    - Publish 1 replica

## Docker CLI Commands

- docker stack deploy -c docker-stack.yml votingapp (if using a yml file)
- or individual create each service
- docker network create -d overlay frontend
- docker network create -d overlay backend
- docker service create --name vote -p 5000:80 --network frontend --replicas 4 dockersamples/examplevotingapp_vote
- docker service create --name redis --network frontend --replicas 4 redis:alpine
- docker service create --name worker --network frontend --network backend --replicas 4 dockersamples/examplevotingapp_worker
- docker service create --name db --network backend -v db-data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=somepassword postgres:15-alpine
- docker service create --name result --network backend dockersamples/examplevotingapp_result
- docker service ps $(docker service ls -q) --filter "desired-state=running" --format "table {{.ID}}\t{{.Name}}\t{{.Node}}" -> to show the list of service running formatted into a table with only the ID, Name of Container & Node that the service is running on
