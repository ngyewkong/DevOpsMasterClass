# Docker Swarm Stack Lab

## Build Docker image

- docker build --tag web_app .

## Tag Docker image (for pushing to dockerhub)

- docker tag web_app:latest ngyewkong/web_app:1.0

## Push to dockerhub

- docker login
- docker push ngyewkong/web_app:1.0

## Deploy using docker-compose.yml

- docker stack deploy -c docker-compose.yml webapp
- docker stack ls (list the stack)
- docker stack ps webapp (see the containers)

## vertical scaling (is a maintenance free activity in docker)

- vertical scaling do not terminate tasks in the existing stack
- no app downtime (vertical scaling up or down)
- update the docker-compose.yml files to 10 replicas instead of 5
- docker stack deploy -c docker-compose.yml webapp (this will update the number of deployed instances to 10)

## horizontal scaling (increase the memory of each instance)

- horizontal scaling (increasing or decreasing cpu or memory)
- shutdown each instance and create a new instance to replace
- rolling update (all services will not shutdown at the same time)
- will not face downtime
