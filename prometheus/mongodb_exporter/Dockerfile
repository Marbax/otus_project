FROM golang:alpine as builder

ARG MONGO_EXPORTER_VERSION=0.6.3

RUN apk --no-cache --update add git curl make libc-dev gcc libgcc && \
    curl -s https://glide.sh/get | sh && \
    mkdir -p  /go/src/github.com/percona/mongodb_exporter \
    && cd /go/src/github.com/percona/mongodb_exporter \
    &&  git clone --depth 1 --branch v"$MONGO_EXPORTER_VERSION" https://github.com/percona/mongodb_exporter.git . && \
    cd /go/src/github.com/percona/mongodb_exporter && make build

FROM busybox:1.30
EXPOSE 9216
COPY --from=builder /go/src/github.com/percona/mongodb_exporter/mongodb_exporter /bin/mongodb_exporter

ENTRYPOINT [ "mongodb_exporter" ]
