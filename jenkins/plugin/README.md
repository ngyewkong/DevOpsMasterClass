# Hello World Plugin Demo

Build a simple "Hello, World" plugin using a template.

# Install Java and Maven

-- Java is Already Installed

# Install Maven

Download Maven Tar from https://maven.apache.org/download.cgi Unzip tar - tar -xvzf <file_name> move to /opt -- mv apache-maven**\*\*** /opt/
wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz

# Add the following lines to the user profile file (.profile).

vim ~/.profile & paste the below lines
M2_HOME='/opt/apache-maven-**\*\***' eg -> /opt/apache-maven-3.9.6
PATH="$M2_HOME/bin:$PATH"
export PATH

Relaunch the terminal or execute source ~/.profile to apply the changes.
Execute mvn --version command

# Create a local folder for the source code:

mkdir -p hello-world cd hello-world

# Create a plugin from the Jenkins templates:

mvn -U archetype:generate -Dfilter="io.jenkins.archetypes:"

mvn verify mvn package

Move .hpi file from targets to Jenkins Plugin Directory Retstart the Jenkins Service

LogIn Jenkins and follow below steps -

New freestyle job
Add "Hello World" build step
Run, check console
