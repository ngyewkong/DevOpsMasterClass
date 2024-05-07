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
