FROM alpine

RUN apk add --update mysql --no-cache

COPY my.cnf /etc/mysql/my.cnf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh entrypoint.sh

EXPOSE 3306
