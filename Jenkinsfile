#!groovy
// Run this node on a Maven Slave
// Maven Slaves have JDK and Maven already installed
node('maven') {
  // Make sure your nexus_openshift_settings.xml
  // Is pointing to your nexus instance
  def parksmapMvnCmd       = "mvn -s ./nexus_openshift_settings.xml"
  def parksmap = "parksmap-web"

  stage('Checkout Source') {
    // Get Source Code from SCM (Git) as configured in the Jenkins Project
    // Next line for inline script, "checkout scm" for Jenkinsfile from Gogs
    //git 'http://gogs-xyz-gogs.192.168.99.100.nip.io/CICDLabs/ParksMap.git'
    checkout scm
  }



  // The following variables need to be defined at the top level and not inside
  // the scope of a stage - otherwise they would not be accessible from other stages.
  // Extract version and other properties from the pom.xml
  //def groupId    = getGroupIdFromPom("pom.xml")
  //def artifactId = getArtifactIdFromPom("pom.xml")
  def parksmapversion    = getVersionFromPom("parksmap-web/pom.xml")

  stage('Build parksmap-web war') {
    echo "Building version ${parksmapversion}"

    
    
    sh "cd ${parksmap}; ${parksmapMvnCmd} clean package -DskipTests"
  }
  
}
 

// Convenience Functions to read variables from the pom.xml
def getVersionFromPom(pom) {
  def matcher = readFile(pom) =~ '<version>(.+)</version>'
  matcher ? matcher[0][1] : null
}