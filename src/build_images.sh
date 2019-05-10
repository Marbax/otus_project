#!/bin/bash
echo "Enter username for docker hub"
read USER_NAME
echo "Enter tag for images"
read IMAGES_TAG
# build app
for i in crawler-ui crawler-app; do cd $i; docker build . -t $USER_NAME/$i:$IMAGES_TAG && docker push $USER_NAME/$i:$IMAGES_TAG; cd -; done
# build monitoring
docker build -t $USER_NAME/prometheus:$IMAGES_TAG prometheus/
docker push $USER_NAME/prometheus:$IMAGES_TAG
docker build -t $USER_NAME/blackbox:$IMAGES_TAG prometheus/blackbox/
docker push $USER_NAME/blackbox:$IMAGES_TAG
docker build -t $USER_NAME/grafana:$IMAGES_TAG prometheus/grafana/
docker push $USER_NAME/grafana:$IMAGES_TAG
docker build -t $USER_NAME/mongodb_exporter:$IMAGES_TAG prometheus/mongodb_exporter/
docker push $USER_NAME/mongodb_exporter:$IMAGES_TAG
docker build -t $USER_NAME/alertmanager:$IMAGES_TAG prometheus/alertmanager/
docker push $USER_NAME/alertmanager:$IMAGES_TAG
# build logging
docker build -t $USER_NAME/fluentd:$IMAGES_TAG fluentd/
docker push $USER_NAME/fluentd:$IMAGES_TAG
