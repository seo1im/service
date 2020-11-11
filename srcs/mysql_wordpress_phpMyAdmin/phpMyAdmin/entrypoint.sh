# https://wiki.alpinelinux.org/wiki/Nginx_with_PHP

adduser -D -g 'www' www

mkdir /www
chown -R www:www /var/lib/nginx
chown -R www:www /www

echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HTML5</title>
</head>
<body>
    Server is online
</body>
</html>' > /www/index.html

echo '<?php
	phpinfo();
?>' > /www/phpinfo.php

mkdir /www/phpmyadmin
tar -xvf /tmp/phpMyAdmin-4.9.4-all-languages.tar.gz --strip-components 1 -C /www/phpmyadmin

mv /tmp/config.inc.php /www/phpmyadmin

mkdir -p /run/nginx

php-fpm7
/usr/sbin/nginx -g "daemon off;"