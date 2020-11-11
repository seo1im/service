FROM alpine

RUN apk add --update openssh nginx --no-cache

RUN mkdir -p /etc/nginx/ssl
COPY srcs/ssl/ssl.key /etc/nginx/ssl/ssl.key
COPY srcs/ssl/ssl.crt /etc/nginx/ssl/ssl.crt
COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/index.html /var/www/localhost/htdocs/index.html

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT sh /entrypoint.sh

EXPOSE 443 80 22
