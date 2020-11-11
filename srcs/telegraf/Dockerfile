FROM alpine

RUN apk add --update telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --no-cache
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh entrypoint.sh