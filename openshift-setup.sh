









//Create project and jenkins permission
oc new-project development --display-name "Development"
oc policy add-role-to-user view -z default
oc policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n development


oc new-project test-env
oc policy add-role-to-user view -z default
oc policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n test-env


oc new-project prod-env
oc policy add-role-to-user view -z default

oc policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n prod-env



//Create  PARKSMAP-WEB template for development
oc project development
oc new-build --binary=true --name="parksmap-web" openshift/redhat-openjdk18-openshift:latest

oc new-app development/parksmap-web:TestingCandidate-1.0 --name=parksmap-web --allow-missing-imagestream-tags=true

oc set triggers dc/parksmap-web --manual

oc expose dc parksmap-web --port 8080

//Dev probe
oc set probe dc/parksmap-web --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/
oc set probe dc/parksmap-web --readiness --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/


oc expose svc parksmap-web


//app template for test 
oc project test-env 
oc new-build --binary=true --name="parksmap-web" openshift/redhat-openjdk18-openshift:latest

oc new-app test-env/parksmap-web:TestReady-1.0 --name=parksmap-web --allow-missing-imagestream-tags=true

oc set triggers dc/parksmap-web --manual

oc expose dc parksmap-web --port 8080

//Test probe
oc set probe dc/parksmap-web --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/
oc set probe dc/parksmap-web --readiness --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/

oc expose svc parksmap-web

//PARKSMAP WEB 
//app template for Production 
oc project prod-env

oc policy add-role-to-group system:image-puller system:serviceaccounts:prod-env -n test-env
oc policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n prod-env
oc new-app test-env/parksmap-web:ProdReady-1.0 --name=parksmap-green --allow-missing-imagestream-tags=true
oc new-app test-env/parksmap-web:ProdReady-1.0 --name=parksmap-blue --allow-missing-imagestream-tags=true

oc set triggers dc/parksmap-green --manual
oc set triggers dc/parksmap-blue --manual
//Prod Probe
oc set probe dc/parksmap-green --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/
oc set probe dc/parksmap-blue --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/

oc set probe dc/parksmap-green --readiness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/
oc set probe dc/parksmap-blue --readiness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/

oc expose dc parksmap-blue --port 8080
oc expose dc parksmap-green --port 8080
oc expose svc/parksmap-green --name parksmap-web





//NATIONAL NATIONAL PARKS 
//app template for development

oc project development
//Deploy a mongo DB instance in the same project 

oc new-build --binary=true --name="nationalparks" openshift/redhat-openjdk18-openshift:latest

oc new-app development/nationalparks:TestingCandidate-1.0 --name=nationalparks --allow-missing-imagestream-tags=true

oc set triggers dc/nationalparks --manual




//Dev probe
oc set probe dc/nationalparks --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/
oc set probe dc/nationalparks --readiness --get-url=http://:8080/ws/healthz/

//Create configmap for Development to externalize MongoDB connection parameter
oc create configmap nationalparks --from-file=application.properties=./application-dev.properties
oc set volumes dc/nationalparks --add -m /deployments/config --configmap-name=nationalparks
oc expose svc nationalparks

oc label route nationalparks type=parksmap-backend


//NATIONAL NATIONAL PARKS 
//app template for TEST, 128203

oc project test-env 
oc new-build --binary=true --name="nationalparks" openshift/redhat-openjdk18-openshift:latest

oc new-app test-env/nationalparks:TestReady-1.0 --name=nationalparks --allow-missing-imagestream-tags=true

oc set triggers dc/nationalparks --manual

oc expose dc nationalparks --port 8080


//Dev probe
oc set probe dc/nationalparks --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/
oc set probe dc/nationalparks --readiness --get-url=http://:8080/ws/healthz/

//Create configmap for test
oc create configmap nationalparks --from-file=application.properties=./application-test.properties
oc set volumes dc/nationalparks --add -m /deployments/config --configmap-name=nationalparks
oc expose svc nationalparks
oc label route nationalparks type=parksmap-backend


//NATIONAL PARK 
//app template for Production 
oc project prod-env

oc policy add-role-to-group system:image-puller system:serviceaccounts:prod-env -n test-env
oc policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n prod-env
oc new-app test-env/nationalparks:ProdReady-1.0 --name=nationalparks-green --allow-missing-imagestream-tags=true
oc new-app test-env/nationalparks:ProdReady-1.0 --name=nationalparks-blue --allow-missing-imagestream-tags=true
oc set triggers dc/nationalparks-green --manual
oc set triggers dc/nationalparks-blue --manual

//Set probe
oc set probe dc/nationalparks-green --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/
oc set probe dc/nationalparks-blue --liveness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:8080/ws/healthz/

oc set probe dc/nationalparks-blue --readiness --get-url=http://:8080/ws/healthz/
oc set probe dc/nationalparks-green --readiness --get-url=http://:8080/ws/healthz/

//Create configmap for production
oc create configmap nationalparks --from-file=application.properties=./application-prod.properties
oc set volumes dc/nationalparks-green --add -m /deployments/config --configmap-name=nationalparks
oc set volumes dc/nationalparks-blue --add -m /deployments/config --configmap-name=nationalparks

oc expose dc nationalparks-blue --port 8080
oc expose dc nationalparks-green --port 8080

oc expose svc/nationalparks-green --name nationalparks
oc label route nationalparks type=parksmap-backend











