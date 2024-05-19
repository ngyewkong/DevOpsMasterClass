# Docker

## Networking

- Default Bridge
- Bridge (Custom/Dedicated)
- Host

## DNS Concepts (Domain Name System)

- Map Domain Names into IP Addresses
- Containers in different networks cannot communicate with one another
- docker exec -it alpine1 ping nginx1 -> result in error ping: bad address 'nginx1'
- Containers in the same network can communicate with one another using container name (DNS)

  - Pro: when containers dies or restarts, it will not keep the same ip address
  - This will ensure we do not need to hardcode the IP address to communicate with other containers
  - alpine1 IP 172.19.0.2 alpine2 initial IP 172.19.0.3
  - stopping alpine2 and create alpine3 and restart alpine2
  - alpine1 IP 172.19.0.2 alpine2 IP 172.19.0.4 alpine3 IP 172.19.0.3 (alpine2 IP gt changed)

- docker exec -it alpine1 ping alpine2
  - PING alpine2 (172.19.0.3): 56 data bytes 64 bytes from 172.19.0.3: seq=0 ttl=64 time=0.190 ms
  - able to ping using container names within the same network

## Useful CLI Commands

- docker run -d --network dns_bridge -p 8083:80 --name alpine2 nginx:alpine (spin a container with a custom network)
- docker network ls
- docker network ls -f driver=bridge (to filter only bridge network type)
- docker network ls -f name=bridge (filter network that has bridge in its name)
- docker network create dns_bridge (default type is bridge if not specified)
- docker network inspect dns_bridge
- docker network rm dns_bridge (for not in use networks)
- docker network prune (remove all custom networks not used by at least 1 container)
- docker network connect dns_bridge [container_name]

## Docker Image Layers & Tags

- Docker will check layer by layer if there is an existing cache version of the layer available on local before pulling
- save bandwidth during download or upload of the Docker image
- tag -> releaase/variant
- can be explicitly tagged as well

## Useful CLI Commands

- docker images
- docker pull image_name:tag (eg. redis:6.2)
- docker history image_name:tag (get the history/how the image is built/size of each layer etc)
- docker tag wordpress:latest local_wordpress:1.0.0 (retag an image to another copy)
- docker push your_registry_username/image_name (after docker login, the image in local must follow your_registry_name/image_name as well)

## Dockerfile

## FROM Base Layer (Reference Base Image)

FROM baseImageName:tag

## Label (to organise images by project, record licensing information etc) using Key-Value Pairs

"\" to handle multi-line annotations
LABEL com.example.version="0.01=beta" \
 org.opencontainers.image.author='MariaDBCommunity' \

## RUN (execute commands in a new layer on top of the current image and commit the results)

eg after pulling base image and we want to download certain packages/dependencies into the image for use ltr on
Install wget/curl to download the dependencies
Download the artifacts
Can run shell commands as well

RUN apt-get update
RUN apt-get install -y curl

## CMD (to run the software contained by your image along with any arguments)

Only one CMD instruction per Dockerfile (only the last CMD will take effect if there is more than 1 CMD)
Usually the last operation in the Dockerfile

CMD["executable","param1","param2"]

## EXPOSE (ports on which a container is listening for connections)

EXPOSE portNumber

## ENV (sets the environment variable to the value)

eg use ENV to update the PATH env variable for the software the container installs

## ADD (copies new files/directories from src & add to filesystem of image at dest path)

ADD hom\* /mydir/ (this will add all files starting with "hom")

## VOLUME (used to expose any db storage area, configuration storage or files/folders created by your docker container)

## WORKDIR (sets the working directory for RUN, CMD, ADD commands used in the Dockerfile)

## Build Docker Image

- docker build -t imageName:TagName dir-containing-the-dockerfile

## Docker Volumes - Persistent Data

- Containers are immutable - Once deployed can only redeploy not able to make changes on the container
- Containers are Stateless - refresh or restart will override the existing state of the container back to the default (data lost)
- By default, all files created inside a container are stored on a writable container layer
- Data does not persist when container no longer exists, hard to get data out of the container if another process needs it
- Docker gt two solns: store files in host machine either using volumes or bind mounts
- During Volume creation, it is stored within a directory on the Docker host machine.
- Created and managed by containers
- Can be set in Dockerfile using VOLUME keyword

## Useful CLI Commands

- docker inspect imageName eg docker inspect mysql
  - eg Volume being specified in mysql image ("/var/lib/mysql": {})
- docker inspect containerName eg docker inspect mysqldb
  - in Mounts section,the source (location on docker machine) and destination (location in container) are being specified
  - "Source": "/var/lib/docker/volumes/d1bea13b56874e802845f1f5c919bef3faadd018f83b116928bb494f3e05924b/\_data" (anon volumes)
  - "Destination": "/var/lib/mysql"
- docker volume ls to show volumes created
- stopping a container will not remove the volume
- setting custom volume using --mount flag
  - docker run -d --name mysqldb3 -e MYSQL_ALLOW_EMPTY_PASSWORD=True --mount source=mysql-db,destination=/var/lib/mysql mysql (using --mount)
  - docker run -d --name mysqldb3 -e MYSQL_ALLOW_EMPTY_PASSWORD=True -v mysql-db:/var/lib/mysql mysql (using -v)
  - can reuse this volume if we need to restart or start another container

## Bind Mounts

- Bind Mount means a file or dir on the host machine mounted into a container
- Mapping of Host Machine files into container files
- Non-Docker processes on the host machine can modify the files on the bind mounts anytime unlike Docker Volumes which only Docker processes can modify
- Bind Mounts cannot be added in Dockerfile (as it is a hardcoded location on the host machine) unlike Docker Volumes
- good use case for bind mounts:
  - sharing of configuration files from host machine to containers
  - sharing source code or build artifacts btw a dev env on a Docker host and a container

## Useful CLI Commands

- impt the type,soruce,target do not have spaces in btw
- docker run -d -p 1234:80 --name nginx --mount type=bind,source=$(pwd),target=/app,readonly nginx (using --mount)
- docker run -d -p 4321:80 --name nginx -v /"$(pwd)":/app:ro nginx (using -v)
- docker exec --it containerName bash
- in the /app it is mapped to the pwd when the docker container was created with all the files on the filesystem

## Docker Compose

- Single Command for all Image building and Container creation
- Docker Compose is not production ready feature (Docker Swarm is)
- Simulate production deployment scenario on dev machine
- requires a docker-compose.yml file containing all services, networks & volumes for the entire app stack

## Useful CLI Commands

- can use docker compose instead of docker-compose in newer versions of Docker (docker-compose is compatible in newer versions)
- make sure the commands are run in the folder containing the docker-compose.yml file
- docker-compose version
- docker-compose --help
- docker-compose build
- docker-compose up -d
- docker-compose down
- docker-compose push
- docker-compose -f custom-application.yml up -d (to use different filename apart from the convention)
- docker-compose logs
- docker-compose logs serviceName (eg docker-compose logs mongodb)
- docker-compose -f custom-application.yml logs mongodb --tail=5 (show only the last x log output)
- docker-compose -f custom-application.yml logs node-app --follow (follow the container live log output)
- docker-compose -f custom-application.yml exec -it node-app bash (get into shell of the container)

## Docker Swarm - Container Orchestration Tool

- Task Scheduling
- Load Balancing
- Rolling Updates
- Security
- Scaling of containers
- Managing failing or crashed containers
- Perform upgrade of service container with 0 downtime
- Manage containers on different VMs, Nodes
- Docker Swarm is clustering and scheduling tool for Docker Containers
- Orchestration: Deine nodes. Define services. Set how many nodes you want to run and where
- Docker Swarm have 2 types of nodes: Master Node and Worker Node
- Every Swarm starts with one manager node designated as the leader
- Highly available due to its impl of RAFT algo
- Consensus algo to achieve fault tolerance in distributed sys
  - Leader is constantly checking with its fellow managers nodes ans sync their states
- Nodes and Roles: Each RAFT cluster have multiple nodes with the following roles
  - Leader: one leader at a time
  - Follower: replicate the leader actions
  - Candidate
- Leader Election:
  - All nodes start in the follower state
  - Follower do not receive Leader communication for a certain period (election timeout)
  - This Follower transits into a Candidate state and requests for votes from other nodes to become the next Leader
  - If Candidate receives majority votes, it become the new Leader
- Swarm Terminology:
  - Swarm consists of multiple Docker hosts in swarm mode and act as 1. managers (manage membership & delegation) & 2. workers (running the swarm services)
  - Host: Can be a manager, worker or both
  - Service: Define its optimal state (number of replicas, network & storage resources available, ports the service expose to external)
  - Docker Swarm will maintain the Service Desired State (5 replicas set -> it will always maintain 5 running services)
  - Task: A running container which is part of a swarm service & managed by a swarm manager
    - Carry Docker container & commands to run inside the container
    - Once a Task is assigned to a node, it cannot be moved to another node. Can only run on the assigned node or fail.
  - Nodes: Instance of Docker engine participating in Swarm
  - Submit Service definition to the manager node which will dispatch tasks to worker nodes.
  - Manager node will perform the orchestration & cluster mgmt to maintain the desired state of the swarm
  - Worker nodes receive & execute the tasks from manager node
  - Load Balancing
    - Swarm manager uses the internal load balancing called the ingress load balancing to expose the services you want to make available externally to the swarm
    - External Load Balancers (eg cloud load balancers) can access service on the published port of ANY node in the cluster (whether or not the node is running the task for the service)
    - All nodes in the swarm cluster route ingress connections to a running task instance

## Docker Swarm Initialisation

- to check if the node has initalised swarm
  - docker info
  - Swarm: inactive
- at the node execute
  - docker swarm init
    - always choose the public IP address on server VMs with public & private IP addresses.
    - docker swarm init --advertise-addr PUBLIC_IP_ADD
    - the node that executed the swarm init will always be the manager node
      - sample log: Swarm initialized: current node (some node id) is now a manager.
- to add worker node to this swarm cluster
  - docker swarm join --token some-generated-token IP_ADD_OF_MANAGER_NODE
- to add manager node to this cluster
  - docker swarm join-token manager
- to get a list of commands available
  - docker swarm --help
  - docker service --help

## Useful CLI Commands

- docker service ls (show the list of services)
- docker service create imageName commandToRun
  - docker service create alpine ping www.google.com
- docker service ps nameOfService (to show the container)
- docker service update nameOfService --replicas 5 (scaling up the service to 5 replicas)
- even if you run docker container rm -f on one of the container
- it will spin up another container to replace automatically to maintain 5 replicas
  - NAME IMAGE NODE DESIRED STATE CURRENT STATE ERROR PORTS
  - inspiring_pascal.1 alpine:latest docker-desktop Running Running 2 hours ago
  - inspiring_pascal.2 alpine:latest docker-desktop Running Running about a minute ago
  - inspiring_pascal.3 alpine:latest docker-desktop Running Running about a minute ago
  - inspiring_pascal.4 alpine:latest docker-desktop Ready Ready 4 seconds ago
  - \_ inspiring_pascal.4 alpine:latest docker-desktop Shutdown Failed 4 seconds ago "task: non-zero exit (137)"
  - inspiring_pascal.5 alpine:latest docker-desktop Running Running about a minute ago
- docker service inspect nameOfService (to get info abt the service eg how many replicas)
- docker service rollback nameOfService (will rollback to prev deployment of 1 replica)

- free docker swarm online lab (to make use of multiple distributed nodes across diff VMs)

  - https://labs.play-with-docker.com/
  - comes with docker installed & ssh is provided ootb
  - can use the docker templates to spin up nodes for swarm
  - docker node ls (must run from manager node to see the nodes info)
  - cat /etc/os-release (check the os of the node)

- Setup Docker Swarm for Production
  - eg spin up 4 VMs (1 manager + 3 worker)
  - ssh into manager VM (install docker + init swarm)
    - follow docker doc to install
      - https://docs.docker.com/engine/install/ubuntu/
    - docker info
    - Add user to Docker Group
      - sudo usermod -aG docker someUsername
    - docker swarm init --advertise-addr VM_PUBLIC_IP
  - Install Docker CE on all the worker nodes
    - docker swarm join-token worker/manager (generate the token for adding worker/manager to the swarm cluster)
    - docker swarm join --token workerToken/managerToken MANAGER_NODE_PUBLIC_IP
    - Manager nodes can promote worker nodes, worker nodes cannot promote self or other worker nodes
      - docker node promote docker-02 (have to run from existing manager/leader nodes)
      - docker node demote docker-01
      - docker service create --replicas 10 alpine ping www.google.com (can be run in any manager node)

## Docker Swarm Visualizer

- dockersamples/visualizer
- require a docker-compose.yaml file
- docker stack deploy -c docker-compose.yml serviceName
- docker stack ls
- go to the docker-manager-01 IP and hit on port 8090 (where the visualizer service is being run)
- docker service create --name nginx_service --replicas 30 nginx:alpine (create service with a custom name)
- docker service ps nginx_service (will see the containers running on each node)

## Docker Swarm Network

- Docker Swarm use overlay network
  - creates a distributed network among multiple Docker hosts
  - allow containers to communicate inside the single swarm cluster
- When init a swarm cluster or join a Docker host to an existing swarm
  - 2 new networks on created on the Docker host
    - Ingress (Default): Overlay network which handles control and data traffic related to swarm services
      - if Swarm service is not connected to a user-defined Overlay Network, it will connect to Ingress Network
    - Bridge: docker_gwbridge: connects individual Docker node to other nodes particpating in the Swarm
  - User-defined Overlay Network
    - TCP port 2377 for cluster mgmt communications
    - TCP & UDP port 7946 for communications among nodes
    - UDP port 4789 for overlay network traffic
  - Before creating user defined overlay network, docker Swarm must be init on Node or join to existing Swarm cluster

## Docker Swarm Nerwork Lab

- docker network create -d overlay lab_network
- docker service create --name postgres --network lab_network -e POSTGRES_PASSWORD=somepassword postgres (postgresql db)
- docker service create --name drupal --network lab_network -p 8080:80 drupal (frontend)
- postgres & drupal will be running on different nodes (docker02 & docker-01)
- upodate the drupal config page to use postgres (setting the password set during service creation & hostname to use postgres serviceName)
- however drupal can be accessed on port 8080 of the docker-manager-01 ip add or any other nodes IP addresses in the same swarm cluster
  - this also mean ports cannot overlap when executing services in the same Docker Swarm cluster

## Docker Swarm Service Traffic Management

- Swarm Global Traffic Mgmt is related to "Routing Mesh" handled by Swarm internal Load Balancer
- Swarm publish Services on some ports and allow external to access this services (Ingress Routing Mesh)
  - This routing mesh allows each node in the swarm cluster to accept connections on published ports for any service running in the swarm cluster
  - Even if there is no task running on that node
  - Routing mesh routes all incoming req to published ports on available nodes to an active container
    - Routing mesh listens on published port for any IP add assigned to the node
- docker service inspect --format="{{.Endpoint.Spec.Ports}}" serviceName to check service published port
