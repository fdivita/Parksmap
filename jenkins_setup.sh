#Create a new project called xyz-jenkins with a display name of Shared Jenkins:
oc new-project jenkins --display-name "Shared Jenkins"
#Set up a persistent Jenkins instance with 2 GB of memory (otherwise Jenkins crashes frequently) and a persistent volume claim of 4 GB:
oc new-app jenkins-persistent --param ENABLE_OAUTH=true --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi

