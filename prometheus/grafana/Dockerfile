FROM grafana/grafana:6.0.1

ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

WORKDIR /etc/grafana/provisioning/loaddashboards/

COPY ./dashboards/*.json "$GF_PATHS_PROVISIONING/loaddashboards/"
COPY datasource.yaml "$GF_PATHS_PROVISIONING/datasources/"
COPY dashboards.yaml "$GF_PATHS_PROVISIONING/dashboards/"
