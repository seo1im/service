mkdir /app
mkdir -p /run/mysqld

mysql_install_db --user=root > /dev/null

tmp='sql_temp'
touch $tmp

cat << EOF > $tmp
CREATE DATABASE wordpress;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '1111' WITH GRANT OPTION;
EOF

echo 'FLUSH PRIVILEGES;' >> $tmp

/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tmp
rm -f $tmp

exec /usr/bin/mysqld --user=root --console