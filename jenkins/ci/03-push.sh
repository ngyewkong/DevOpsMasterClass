#!/bin/bash
docker image build -t ngyewkong/jenkins-demo:$1 -f jenkins/sample_project/src/demo2-publish/dockerfile .

if [ -z ${DOCKER_HUB_USER+x} ]
then 
    echo 'Skipping login - credentials not set' 
else 
    docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD
fi

docker push ngyewkong/jenkins-demo:$1