FROM nginx:latest

LABEL version="0.0.1" \
    maintainer="ngyewkong"

# Update the working directory for all future commands
WORKDIR /usr/share/nginx/html

# Replace the index.html with custom file to show a different default page
# this will copy the index.html in this extend-nginx dir to the container dest work directory
COPY index.html index.html

# docker build -t ngyewkong/extend-nginx:0.0.1 extend-nginx
# docker run -it -d -p 8091:80 --name custom-nginx-container ngyewkong/extend-nginx:0.0.1