FROM alpine

RUN apk add --update vsftpd openssl --no-cache

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY entrypoint.sh /entrypoint.sh

EXPOSE 20 21 30020 30021

ENTRYPOINT sh /entrypoint.sh