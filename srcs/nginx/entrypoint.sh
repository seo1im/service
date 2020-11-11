export SSH_USER=seolim
export SSH_PASSWORD=12345678

adduser -D "$SSH_USER"
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
ssh-keygen -A

chmod 644 /etc/nginx/ssl/ssl.crt
chmod 600 /etc/nginx/ssl/ssl.key

mkdir -p /run/nginx

/usr/sbin/sshd

/usr/sbin/nginx -g "daemon off;"