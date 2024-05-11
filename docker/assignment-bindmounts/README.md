# Assignment 4 - Bind Mounts

- Start nginx container
- Add bind mount to the nginx container
  - docker run -d -p 1234:80 --name nginx --mount type=bind,source=$(pwd)/assignment-bindmounts,target=/usr/share/nginx/html nginx
  - note that if we exec docker run without using mount (it has the default index.html in the target dir)
  - but it is not having the default file when running with bind mount
- Edit the index.html file in host machine
  - create the file directly in the host machine dir OR
  - docker exec -it nginx bash
  - cd /usr/share/nginx/html
  - vim index.html
- Verify the change on running container
  - check on localhost:1234/index.html has the custom page
