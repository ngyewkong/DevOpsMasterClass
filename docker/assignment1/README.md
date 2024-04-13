# Assignment 1 Step-By-Step

## Setup E2E Web Application

### Web Application - Frontend + Backend

- MariaDB Image simulate Backend (Refer to documentation here: https://hub.docker.com/_/mariadb)
  - setup container name (eg. mariadb-container)
  - set DB root password using env var MARIADB_ROOT_PASSWORD (https://mariadb.com/kb/en/mariadb-server-docker-official-image-environment-variables/)
  - set DB Username (MARIADB_USER), DB Password (MARIADB_PASSWORD), DB Name (MARIADB_DATABASE)
  - execute "docker run -d -e MARIADB_USER=db_user -e MARIADB_PASSWORD=test123 -e MARIADB_DATABASE=assignment1db -e MARIADB_ROOT_PASSWORD=admin123 --name mariadb-container mariadb"
  - execute "docker stats mariadb-container" to check on the mem, cpu usage of the container
  - execute "docker ps" to check if container is up
- Wordpress Image simulate Frontend
  - setup wordpress container name (eg. wordpress-container)
  - set db container name (WORDPRESS_DB_HOST), db name (WORDPRESS_DB_NAME), db user (WORDPRESS_DB_USER), db password (WORDPRESS_DB_PASSWORD)
  - expose wordpress container on port 8080/80 (expose on external port 8080 the internal container port 80 which by default wordpress is running on)
  - execute "docker run -d -p 8080:80 -e WORDPRESS_DB_HOST=mariadb-container -e WORDPRESS_DB_NAME=assignment1db -e WORDPRESS_DB_USER=db_user -e WORDPRESS_DB_PASSWORD=test123 --name wordpress-container wordpress"
  - test container is up by hitting the localhost:PORT or the HOST_IP:PORT in browser (localhost:8080)
  - will not be able to hit as the two containers are not on the same network (will not happen if we use docker orchestration software like k8s or docker swarm) even though the container logs of the mariadb container is showing ready for connection (docker logs mariadb-container)
    - solution: create a custom network with both containers inside the network
      - execute "docker network create assignment-network"
      - execute "docker network connect assignment-network wordpress-container"
      - execute "docker network connect assignment-network mariadb-container"
    - alt solution: stop the running containers and add --network flag when running the containers
      - execute "docker run -d -e MARIADB_USER=db_user -e MARIADB_PASSWORD=test123 -e MARIADB_DATABASE=assignment1db -e MARIADB_ROOT_PASSWORD=admin123 --name mariadb-container --network assignment-network mariadb"
      - execute "docker run -d -p 8080:80 -e WORDPRESS_DB_HOST=mariadb-container -e WORDPRESS_DB_NAME=assignment1db -e WORDPRESS_DB_USER=db_user -e WORDPRESS_DB_PASSWORD=test123 --name wordpress-container --network assignment-network wordpress"
