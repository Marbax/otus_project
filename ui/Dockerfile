FROM alpine:3.9

ENV APP_HOME /app
WORKDIR $APP_HOME

COPY ui $APP_HOME/ui
COPY tests $APP_HOME/tests
RUN mkdir $APP_HOME/templates/
#COPY ui/templates/* $APP_HOME/templates/
COPY requirements.txt $APP_HOME/
COPY requirements-test.txt $APP_HOME/

RUN apk --no-cache add bash uwsgi uwsgi-python py2-pip curl \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r requirements-test.txt

# flask==0.12.2 gunicorn==19.7.1 structlog==17.2.0 pymongo==3.5.1 requests==2.18.4 prometheus_client==0.1.0 uuid

ENV MONGO mongo_db
ENV MONGO_PORT 27017
ENV FLASK_APP $APP_HOME/ui/ui.py

EXPOSE 8000

CMD gunicorn -w 4 --log-level=debug ui:app -b 0.0.0.0
#CMD [ "/usr/local/bin/gunicorn", "--chdir" ,"ui","-b", "0.0.0.0", "ui:app"]