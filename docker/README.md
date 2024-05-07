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
