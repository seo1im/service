FROM alpine

RUN apk add --update influxdb --no-cache
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh /entrypoint.sh

EXPOSE 8086