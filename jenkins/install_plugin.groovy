import jenkins.model.Jenkins;

pm = Jenkins.instance.pluginManager
uc = Jenkins.instance.updateCenter

// Calls Plugin Catalog and Download All the Information that require
pm.doCheckUpdatesServer()

// List of PlugIn with Dependencies
// the name inside the array follow the id listed in jenkins doc (https://plugins.jenkins.io/)
// add pipeline job plugin (https://plugins.jenkins.io/workflow-aggregator/)
// deploy true handles the dependencies installation for each plugin
["github", "mstest", "workflow-aggregator", "docker-build-publish"].each {
  if (! pm.getPlugin(it)) {
    deployment = uc.getPlugin(it).deploy(true)
    deployment.get()
  }
}

// Restart Jenkins after installing plugins (optional)
Jenkins.instance.restart()

// go to Manage Jenkins > Script Console and run this script to install the plugins