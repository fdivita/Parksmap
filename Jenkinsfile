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


  stage('Tests') {
    echo "Unit Tests"
    sh "cd ${parksmap}; ${parksmapMvnCmd} test"        
  }
            
    
    stage('Code Analysis') {
        echo "Code Analysis"
        sh "cd ${parksmap}; ${parksmapMvnCmd} sonar:sonar -Dsonar.host.url=http://sonarqube-sonarqube.192.168.99.106.nip.io  -Dsonar.projectName=${JOB_BASE_NAME}"
    } 

    stage('Publish to Nexus') {
        echo "Publish to Nexus"

        // Replace xyz-nexus with the name of your project
        sh "cd ${parksmap}; ${parksmapMvnCmd} deploy -DskipTests=true -DaltDeploymentRepository=nexus::default::http://nexus3-nexus.192.168.99.106.nip.io/repository/releases"
    }

    stage('Build OpenShift Image') {
        def newTag = "TestingCandidate-${parksmapversion}"
        echo "New Tag: ${newTag}"

        // Copy the jar file we just built and rename to jar.war
        sh "cd ${parksmap};cp ./target/parksmap-web.jar ./ROOT.jar"

        // Start Binary Build in OpenShift using the file we just published
        // Replace xyz-tasks-dev with the name of your dev project
        sh "oc project development"
        sh "cd ${parksmap};oc start-build parksmap-web --follow --from-file=./ROOT.jar -n development"

        openshiftTag alias: 'false', destStream: 'parksmap-web', destTag: newTag, destinationNamespace: 'development', namespace: 'development', srcStream: 'parksmap-web', srcTag: 'latest', verbose: 'false'
    }

    stage('Deploy to Dev') {
    // Patch the DeploymentConfig so that it points to the latest TestingCandidate-${version} Image.
    
    sh "oc project development"
   sh "oc patch dc parksmap-web --patch '{\"spec\": { \"triggers\": [ { \"type\": \"ImageChange\", \"imageChangeParams\": { \"containerNames\": [ \"parksmap-web\" ], \"from\": { \"kind\": \"ImageStreamTag\", \"namespace\": \"development\", \"name\": \"parksmap-web:Test-Ready-$parksmapversion\"}}}]}}' -n development"

    openshiftDeploy depCfg: 'parksmap-web', namespace: 'development', verbose: 'false', waitTime: '', waitUnit: 'sec'
    openshiftVerifyDeployment depCfg: 'parksmap-web', namespace: 'development', replicaCount: '1', verbose: 'false', verifyReplicaCount: 'false', waitTime: '', waitUnit: 'sec'
    openshiftVerifyService namespace: 'development', svcName: 'parksmap-web', verbose: 'false'
  }


}



 

// Convenience Functions to read variables from the pom.xml
def getVersionFromPom(pom) {
  def matcher = readFile(pom) =~ '<version>(.+)</version>'
  matcher ? matcher[0][1] : null
}
 