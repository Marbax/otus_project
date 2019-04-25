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
```docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest && docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false```

