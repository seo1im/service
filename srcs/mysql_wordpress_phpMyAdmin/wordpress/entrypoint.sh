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

tar -xzvf /tmp/latest.tar.gz -C /www
rm -f /tmp/latest.tar.gz

mv /tmp/wp-config.php /www/wordpress/wp-config.php
sed -i "s/__DB_PASSWORD__/$WORDPRESS_DB_PASSWORD/g" /www/wordpress/wp-config.php
sed -i "s/__DB_HOST__/$WORDPRESS_DB_HOST/g" /www/wordpress/wp-config.php

mkdir -p /run/nginx

php-fpm7
/usr/sbin/nginx -g "daemon off;"