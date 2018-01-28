oc new-project xyz-gogs --display-name "Gogs"
oc new-app postgresql-persistent --param POSTGRESQL_DATABASE=gogs --param POSTGRESQL_USER=gogs --param POSTGRESQL_PASSWORD=gogs --param VOLUME_CAPACITY=4Gi -lapp=postgresql_gogs
oc new-app wkulhanek/gogs:11.4 -lapp=gogs

echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gogs-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi" | oc create -f -


oc set volume dc/gogs --add --overwrite --name=gogs-volume-1 --mount-path=/data/ --type persistentVolumeClaim --claim-name=gogs-data
oc expose svc gogs






