# otus_project
project work

## План

 - [ x ] Засунуть приложение в контейнеры 
 - [ x ] Засунуть ui в контейнер
 - [ x ] Найти контейнер MongoDB 
 - [ x ] Найти контейнер RabbitMQ
 - [ x ] Написать docker-compose с зависимостями сервисов
 - [ ] Поднять в GCP docker-host с помощью gcloud
     - [ ] Придумать аналог для терраформа
 - [ ] Проверить работоспособность
 - [ x ] Интегрировать с Gitlab
 - [ ] Интегрировать с Prometheus
     - [ ] Добавить Cadvisor
     - [ ] Добавить Grafana
     - [ ] Добавить Alertmanager
 - [ ] Интегрировать с системой логирования :
     - [ ]  Fluentd 
     - [ ]  Elasticsearch 
     - [ ]  Kibana
     - [ ]  Zipkin

 - [ ] Завернуть все в пакер

Добавление ранера
```
docker exec -it gitlab-runner gitlab-runner register \
  --non-interactive \
  --url "http://192.168.88.12/" \
  --registration-token "pn_6afCNnncRD-5P4Jnv" \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "gitlab-runner-01" \
  --request-concurrency 3 \
  --tag-list "docker,gitlab,gitlab-runner" \
  --run-untagged="true" \
  --locked="false" \
  --docker-privileged
  ```

