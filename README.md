#PARKSMAP CI/CD

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







