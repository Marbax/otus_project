FROM alpine:3.9

ENV APP_HOME /app
WORKDIR $APP_HOME

COPY crawler $APP_HOME/crawler
COPY tests $APP_HOME/tests
COPY requirements.txt $APP_HOME/
COPY requirements-test.txt $APP_HOME/

RUN apk --no-cache add bash uwsgi uwsgi-python py2-pip python3 py3-pip gcc musl-dev \
&& pip3 install --no-cache-dir -r requirements.txt \
&& pip3 install --no-cache-dir -r requirements-test.txt

# beautifulsoup4==4.6.0 requests==2.18.4 pika==0.11.0 structlog==17.2.0 pymongo==3.5.1 prometheus_client==0.1.0

# адрес mongodb-хоста
ENV MONGO mongo_db
# порт для подключения к mongodb-хосту
ENV MONGO_PORT 27017
# адрес rabbitmq-хоста
ENV RMQ_HOST rabbit_mq
# имя очереди rabbitmq
ENV RMQ_QUEUE rabbit_mq
# пользователь для подключения к rabbitmq-серверу
ENV RMQ_USERNAME fox
# пароль пользователя
ENV RMQ_PASSWORD jTmsC9mp24ATewmQ
# минимальное время между повторными проверками одного и того же url
ENV CHECK_INTERVAL 10
# адреса которые будут исключены из обхода записанные через запятую в формате простых регулярных выражений.
ENV EXCLUDE_URLS='.*github.com'

CMD python3 -u crawler/crawler.py https://vitkhab.github.io/search_engine_test_site/
#CMD ["python3", "-u", "crawler/crawler.py", "https://vitkhab.github.io/search_engine_test_site/"]