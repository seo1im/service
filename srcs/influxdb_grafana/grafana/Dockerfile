FROM alpine

RUN apk add --update grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --no-cache
COPY provisioning/influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY provisioning/dashboards.yaml /usr/share/grafana/conf/provisioning/dashboards/
COPY dashboards /var/lib/grafana/dashboards/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh /entrypoint.sh

EXPOSE 3000