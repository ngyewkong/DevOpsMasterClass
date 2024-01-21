# DevOpsMasterClass

## Setup Jenkins Server

- jenkins need at least jdk11
- follow installation (https://pkg.jenkins.io/debian/)
- sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key
- echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
- update package index
  - sudo apt-get update
- install jdk17
  - sudo apt-get install fontconfig openjdk-17-jre
- install jenkins
  - sudo apt install jenkins
- enable jenkins service (if service is not up)
  - sudo systemctl enable jenkins
- cat /var/lib/jenkins/secrets/initialAdminPassword to get the initial password to login
- install plugin

## Demo - Standard Jenkins Build with Manual Plugin SetUp

### Open Jenkins

### Install Utils on Jenkins Host Machine

sudo apt-get update
sudo apt-get install -y dotnet-sdk-7.0
dotnet --version

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT="true" \
 PATH="${PATH}:/root/.dotnet"

### Set up the project & clone the repo

Back to Jenkins UI -> Manage Jenkins -> Plugins -> Available Plugins

- from `Available` tab, search for github
- install GitHub Integration

Create new freestyle job `pi`:

- Git SCM
- repo url `https://github.com/anshulc55/Jenkins_Upgradev3` (no credentials - public)
- branch spec `\*master`
- advanced clone - shallow, depth = 1
- clean before checkout

Build triggers:

- poll scm
- schedule `H/5 * * * *`

Build steps:

- shell `ls`

> Build now and verify repo download

## Build the code

Check for a .NET Core plugin in [the catalogue](https://plugins.jenkins.io/).

- filter on platform .NET

> No way to install .NET Core SDK as a plugin (needs server install).

Add build step:

- this will build the project located at jenkins-plugin-model dir

```
dotnet build ./jenkins-plugin-model/src/Pi.Web/Pi.Web.csproj
```

> Build and check

Add smoke test:

```
dotnet ./jenkins-plugin-model/src/Pi.Web/bin/Debug/netcoreapp3.1/Pi.Web.dll
```

> Build again

## Run tests

Unit tests use NUnit which can output MSTest `.trx` format files.

Add unit test:

```
dotnet test --logger "trx;LogFileName=Pi.Math.trx" ./jenkins-plugin-model/src/Pi.Math.Tests/Pi.Math.Tests.csproj

dotnet test --logger "trx;LogFileName=Pi.Runtime.trx" ./jenkins-plugin-model/src/Pi.Runtime.Tests/Pi.Runtime.Tests.csproj
```

> Build and check console output

Browse workspace for `.trx` files; now we need an MSTest plugin from the [catalogue](https://plugins.jenkins.io/)

- search `trx`
- check `MSTest` plugin details

Back to Jenkins UI -> Manage Jenkins -> Plugins -> Available Plugins

- from `Available` tab
- install MSTest

In `pi` job, add post-build step for MSTest

- default options

> Build

- test results per build
- drill down into tests

> Build again & refresh job page

- with multiple builds trend report at job level

## Demo - Build in Docker

### Publish

Build Docker image and publish to Docker Hub; search for `Docker Hub` in [plugins](https://plugins.jenkins.io/).

- main "Docker" most popular
- but lots of dependencies and lots of features I don't need
- try CloudBees Docker Build & Publish

Back to Jenkins UI -> Manage Jenkins -> Plugins -> Available Plugins

- from `Available` tab
- install CloudBees Docker Build & Publish

In `pi` job, add _build and publish_ step

- repo: `your docker hub repo`
- registry credentials - add new username/password creds
- use Docker Hub username and [authentication token](https://hub.docker.com/settings/security)
- advanced - Dockerfile path

Build now - FAILS (Due to Docker not being installed on Jenkins vm)

- Install Docker in the Jenkins Server

  - apt install docker.io
  - sudo usermod -a -G docker jenkins (add the jenkins user to the Docker group)
  - sudo systemctl status jenkins (check status of jenkins)
  - sudo systemctl restart jenkins (restart jenkins service)
  - rebuild job in jenkins ui
  - build will fail again during docker push (permission denied)
    - fix: add a sh block in front to login to Docker Hub first

- add build environment, hub creds:
  - `DOCKER_HUB_USER`
  - `DOCKER_HUB_PASSWORD`
  - use the docker credentials saved in jenkins
- add build step, before build & push

```
docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD
```

## Demo - Offline Installation in Jenkins VM (install plugins directly in server)

- cd /var/lib/jenkins/plugins
- GitHub Plugin: wget https://updates.jenkins.io/download/plugins/github/1.37.3.1/github.hpi
- MSTest Plugin: wget https://updates.jenkins.io/download/plugins/mstest/1.0.5/mstest.hpi
- Docker Plugin: wget https://updates.jenkins.io/download/plugins/docker-build-publish/1.4.0/docker-build-publish.hpi
- sudo systemctl restart jenkins
- Note: this way of installing plugins WILL NOT HANDLE plugins dependencies...
- Will need to handle it ourselves (be it through a bundle in an artifactory etc)
