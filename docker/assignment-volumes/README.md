# Assignment 3 - Named Volumes

## DB upgrade with Volumes in Containers

- Create mysql container with some specific version with named volume (mysqldb-vol)
  - docker run -d --name mysqldb -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --mount source=mysqldb-vol,destination=/var/lib/mysql mysql:8.0.37
- Verify container status
  - docker ps
- Create some data in db

  - docker exec -it mysqldb bash
  - mysql (mysql version 8.0.37)
  - SHOW DATABASES;
  - CREATE DATABASE assignmentdb;
  - USE assignmentdb;
  - SHOW TABLES;
  - CREATE TABLE inventory (name VARCHAR(20), qty SMALLINT);
  - INSERT INTO inventory VALUES ('iPhone', 1234), ('MacBook', 4321), ('iPad', 3000);
  - SELECT \* FROM inventory; (3 rows added)

- stop and rm the container
  - docker rm -f mysqldb (mysqldb-vol is still persisted)
- start the new mysql container with the existing named volume and verify data persistence
  - docker run -d --name mysqldb-latest -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --mount source=mysqldb-vol,destination=/var/lib/mysql mysql:8.4
  - docker exec -it mysql-latest bash
  - mysql (mysql version 8.4.0)
  - USE assignmentdb;
  - SELECT \* FROM inventory; (3 rows still persisted)
