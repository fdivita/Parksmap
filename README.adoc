PARKSMAP CI/CD

Parksmap CI/CD demo


Overview
The repo contains scripts and templates to setup a  CI/CD environment for the parksmap-web and national parks application
The setup scripts will install the following projects :

development, test-env and prod-env for development,  integration test and production stages
CI/CD: Jenkins, Sonarqube, Gogs, , Nexus

Jenkins Pipeline stages 
Two Jenkins pipelines are provided:

Jenkins_nationalparks, to build in dev, test-env and prod-env the nationalparks  application
Jenkins-parksmap, to build in dev, test-env and prod-env the parksmap-web application
The following picture is a graphic representation of the pipeline (the two pipeline s follow the same workflow)
Here it is a brief explanation of the main steps:

Checkout Source Code: the source code is checked out from the dogs repository
Build .jar: the jar file is build using maven repository stored in nexus
Tests and Code Analysis: the unit tests and Code Analysis ( using Sonarqube ) tests are run in parallel
Publish to Nexus: the .jar file is stored in the Nexus repo
Build Openshift Image in development: the image, using S2I template, is built in the development namespace and is tagged as ready to be tested with the tag TestReady-APPVERSION-BUILDNUMBER
Deploy to Development: the image is deployed into the development namespace, patching the deployment configuration
Integration Test: a rollout of the image is triggered in the integration test. A simulated integration test is run  and in case of a success , the image is tagged as ProdReady-APPVERSION-BUILDNUMBER and deployed
Deploy to Pre-Production with Blue/Green: the production rollout is started and using a Blue/Green strategy a new version of the service is deployed
Switch over to new version: the exposed route is patched in order to point to the latest version of the service 

Replace in the two jerkins pipeline the URLs pointing to Nexus , Gogs, Sonarqube with the ones pointing to your CI/CD tools

Set up
Login into Openshift , replacing the URL of the master 

oc login https://mymaster.openshift.com:8443

Sonarqube Setup: sonarQube-setup.sh contains all the required scripts to setup Sonarqube

Gogs setup: the gogs_setup.sh contains all the required scripts to setup Gogs environment;  to configure it , look at the instructions in gogs-config. 

Nexus setup:  nexus-setup.sh contains all the required scripts to install Nexus repository . To setup the maven repo in Nexus use the create_maven_rep.sh

Jenkins setup: use the jenkins_setup.sh script. After deploying it , login into jenkins and import the two pipelines. Replace all the URL related to Gogs, Nexus and Sonarqube with the ones running in your openshift environment

Openshift environment setup: openshift-setup.sh setups the three environments development , test-env , prod-env and the related parksmap-web and nationalparks applications






