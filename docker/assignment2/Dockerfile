# Assignment requirements
# download latest python image
FROM python:latest

# write a python program (eg main.py)
# set the workdir & copy the main.py
WORKDIR /usr/src/app
COPY main.py  ./

# run the python program in the container
CMD ["python", "./main.py"]

# tag and push the image to Docker Hub
# docker build -t ngyewkong/pythonhello assignment2/
# docker push ngyewkong/pythonhello
# docker run -it --rm --name py-assignment ngyewkong/pythonhello

# remove the image from local and run the container again
# docker rmi ngyewkong/pythonhello