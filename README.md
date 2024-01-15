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
