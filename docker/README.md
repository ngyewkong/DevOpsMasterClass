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
