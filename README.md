# otus_project
project work


<details><summary> План </summary><p>

 - [x] Описать докерфайл для crawler-app
 - [x] Описать докерфайл для crawler-гш
 - [x] Найти контейнер MongoDB 
 - [x] Найти контейнер RabbitMQ
 - [x] Написать docker-compose с зависимостями сервисов
 - [x] Поднять в GCP docker-host с помощью gcloud
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
 - [x] Завернуть все в пакер

</p></details>

<details><summary> Требования для хоста еластики(если не через пакер) </summary><p>

- Нужен увеличеный размер памяти под процесс по требованиям джавы (78 ошибка):
 - до ребута ```sudo sysctl -w vm.max_map_count=262144```
 - навсегда ```sudo echo "vm.max_map_count=262144" >> /etc/sysctl.conf```

</p></details>


<details><summary> Описание репозитория </summary><p>

- ```crawler-app/``` Приложение вместе с докерфайлом
- ```crawler-ui/``` Веб интерфейс приложения вместе с докерфайлом
- ```prometheus/``` Система мониторинга с докерфайлами и конфигами
- ```fluentd/``` Сборщик логов fluentd с докерфайлом и конфигом
- ```packer/``` Описаный backed образ платформы
- ```terraform/``` Terraform манифест для поднятия платформы в GCP

</p></details>

<details><summary> Правила фаерволла для доступа к сервисам(terraform сам их откроет) </summary><p>

(Правила согласно открытым портам контейнеров ,указаным в env файлах)

```
- Правило для доступа к docker-machine ,если создается через нее, в других случаях надобности в нем нет
gcloud compute firewall-rules create "tcp-host-rule" --allow tcp:2376 \
      --source-ranges="93.126.79.67/32" \
      --description="Access to docker-machine host"

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

<details><summary> Использование </summary><p>

### Для использования нужны :
- Docker version 17.05.0-ce (минимум,подойдет и версия из apt)
- docker-compose version 1.17.1 (минимум,подойдет и версия из apt)
- Нужно быть зарегестрированым в dockerhub (для создания своих образов)
- packer version 1.3.3 (минимум)
- Terraform v0.11.9
- У packer и terraform должен быть открыт доступ к управлению ресурсами GCP
- Google Cloud SDK 240.0.0 (минимум)

### 1.Собрать контейнеры приложения и инфраструктуры:
- В ```prometheus/alertmanager/config.yml``` добавить свои данные для алертов в slack
- ```src/build_images.sh``` скрипт для интерактивного билда контейнеров и пуша на свой аккаунт dockerhub

### 2.Отредактировать переменные окружения для compose файлов:
- ```.env.example``` переименовать в ```.env``` (Если не трогать ,будут браться тестовые контейнеры)

### 3.Собрать образ платформы с помощью packer:
- ```packer/variables.json.example``` переименовать в ```packer/variables.json``` отредактировать переменные (как минимум project_id)
- Сбилдить образ из корня репозитория ```packer build -var-file=packer/variables.json packer/immutable.json```
- Возможен баг ,что при сборке не сможет поставить docker ,просто повторить сборку 

### 4.Поднять инстанс с помощью terraform:
- ```terraform/terraform.tfvars.example``` переименовать в ```terraform/terraform.tfvars``` отредактировать переменные (как минимум project поставить свой проект , disk_image поставить образ диска ,который сделает пакер)
- Сделать ```terraform init ``` в директории ```terraform/``` , затем ```terraform apply -auto-approve``` для поднятия инстанса

### 5. Настройка логирования:
- Добавить на kibana pattern fluentd в вебе(по дэфолту IP:5601)

### 5. Создать раннер для приложения 

<details><summary>Добавление ранера</summary><p>

```
docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```

- Урл и токен можно посмотреть в Ваш_проект_на_гитлабе -> Settings -> CI/CD -> Runners

```
docker exec -it gitlab-runner gitlab-runner register \
  --non-interactive \
  --url "http://35.214.113.63:8888/" \
  --registration-token "UhqFfYZRxR3GpaafG_vD" \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "crawler-runner-01" \
  --request-concurrency 3 \
  --tag-list "docker,gitlab,crawler,crawler-runner" \
  --run-untagged="true" \
  --locked="false" \
  --docker-privileged

```

</p></details>

</p></details>


