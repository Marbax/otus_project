# otus_project
project work


<details><summary> План </summary><p>
 - [x] Описать докерфайл для crawler-app
 - [x] Описать докерфайл для crawler-гш
 - [x] Найти контейнер MongoDB 
 - [x] Найти контейнер RabbitMQ
 - [x] Написать docker-compose с зависимостями сервисов
 - [ ] Поднять в GCP docker-host с помощью gcloud
 - [x] Проверить работоспособность
 - [x] Интегрировать с Gitlab
 - [x] Интегрировать с Prometheus
     - [x] Добавить Cadvisor
     - [x] Добавить Grafana
     - [x] Добавить Alertmanager
 - [x] Интегрировать с системой логирования :
     - [x]  Fluentd 
     - [x]  Elasticsearch 
     - [x]  Kibana
     - [ ]  Zipkin (не видит сервисов)

 - [ ] Завернуть все в пакер
</p></details>


<details><summary> Требования для хоста еластики </summary><p>

- Нужен увеличеный размер памяти под процесс по требованиям джавы (78 ошибка):
 - до ребута ```sudo sysctl -w vm.max_map_count=262144```
 - навсегда ```sudo echo "vm.max_map_count=262144" >> /etc/sysctl.conf```

- Структуру репозитория менять не желательно во измежание ошибок 

- docker-compose можно ставить из apt (проверено на версии 1.17.1)

</p></details>


<details><summary> Описание репозитория </summary><p>

- Приложение вместе с докерфайлом по пути ```crawler-app/```
- Веб интерфейс приложения вместе с докерфайлом по пути ```crawler-ui/```

</p></details>


<details><summary>Добавление ранера</summary><p>
```
docker exec -it gitlab-runner gitlab-runner register \
  --non-interactive \
  --url (адресс_гитлаба_напр)"http://192.168.88.12/" \
  --registration-token (токен_из_гитлаба_напр)"pn_6afCNnncRD-5P4Jnv" \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "crawler-runner-01" \
  --request-concurrency 3 \
  --tag-list "docker,gitlab,crawler-runner" \
  --run-untagged="true" \
  --locked="false" \
  --docker-privileged
  ```
</p></details>


<details><summary> Создание хоста для платформы </summary><p>
```
docker-machine create --driver google \
    --google-project docker-231712 \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1804-lts \
    --google-disk-size 100 \
    --google-zone europe-west1-b \
    --google-tags http-server,crawler,app-platform \
    --google-machine-type n1-standard-4 \
    crawler-platform
```
- Переключение окружения докера на удаленное ```eval $(docker-machine env crawler-platform)```

</p></details>


<details><summary> Правила фаерволла для доступа к сервисам </summary><p>
(Правила согласно открытым портам контейнеров ,указаным в env файлах)

```
gcloud compute firewall-rules create "tcp-host-rule" --allow tcp:2376 \
      --source-ranges="93.126.79.67/32" \
      --description="Access to docker-machine host"

gcloud compute firewall-rules create "tcp-ui-http-rule" --allow tcp:443 \
      --source-ranges="0.0.0.0/0" \
      --description="HTTPs access for aplication ui"

gcloud compute firewall-rules create "tcp-ui-https-rule" --allow tcp:80 \
      --source-ranges="0.0.0.0/0" \
      --description="HTTP access for aplication ui"

gcloud compute firewall-rules create "tcp-prometheus-rule" --allow tcp:9090 \
      --source-ranges="93.126.79.67/32" \
      --description="HTTP access for prometheus"

gcloud compute firewall-rules create "tcp-cadvisor-rule" --allow tcp:8080 \
      --source-ranges="93.126.79.67/32" \
      --description="HTTP access for cadvisor"

gcloud compute firewall-rules create "tcp-grafana-rule" --allow tcp:3000 \
      --source-ranges="93.126.79.67/32" \
      --description="HTTP access for grafana (monitoring)"

gcloud compute firewall-rules create "tcp-kibana-rule" --allow tcp:5601 \
      --source-ranges="93.126.79.67/32" \
      --description="HTTP access for kibana (logging)"

gcloud compute firewall-rules create "tcp-http-gitlab-rule" --allow tcp:8888 \
      --source-ranges="93.126.79.67/32" \
      --description="HTTP access for gitlab"

gcloud compute firewall-rules create "tcp-ssh-gitlab-rule" --allow tcp:2222 \
      --source-ranges="93.126.79.67/32" \
      --description="SSH access for gitlab"

gcloud compute firewall-rules create "tcp-alertmanager-rule" --allow tcp:9093 \
      --source-ranges="93.126.79.67/32" \
      --description="HTTP access for alertmanager"

```
</p></details>

