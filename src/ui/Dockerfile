FROM alpine:3.9

ENV APP_HOME /app
WORKDIR $APP_HOME

COPY ui/* $APP_HOME/
RUN mkdir $APP_HOME/templates/
COPY ui/templates/* $APP_HOME/templates/

RUN apk --no-cache add bash uwsgi uwsgi-python py2-pip curl \
    && pip install --upgrade pip \
    && pip install flask==0.12.2 gunicorn==19.7.1 structlog==17.2.0 \
    pymongo==3.5.1 requests==2.18.4 prometheus_client==0.1.0 uuid \

ENV MONGO mongo_db
ENV MONGO_PORT 27017

EXPOSE 8000

CMD FLASK_APP=ui.py gunicorn -w 4 --log-level=debug ui:app -b 0.0.0.0
#CMD ["gunicorn"  , "-b", "0.0.0.0:8000", "ui:app"]