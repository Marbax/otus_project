#!/bin/bash
echo "Enter username for docker hub"
read USER_NAME
docker build -t $USER_NAME/prometheus:otus_project .
docker push $USER_NAME/prometheus:otus_project
docker build -t $USER_NAME/blackbox:otus_project ./blackbox/
docker push $USER_NAME/blackbox:otus_project
docker build -t $USER_NAME/grafana:otus_project ./grafana/
docker push $USER_NAME/grafana:otus_project
docker build -t $USER_NAME/mongodb_exporter:otus_project ./mongodb_exporter/
docker push $USER_NAME/mongodb_exporter:otus_project
