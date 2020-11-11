echo "get external ip"
wordpress=$(kubectl describe svc wordpress-service | grep "LoadBalancer Ingress" | cut -f 2 -d ':' | tr -d ' ')
phpmyadmin=$(kubectl describe svc phpmyadmin-service | grep "LoadBalancer Ingress" | cut -f 2 -d ':' | tr -d ' ')

echo "process re nginx"
sed "s/WORDPRESS_IP/$wordpress/g" ./srcs/form/nginx.conf > ./srcs/form/nginx_w.conf
sed "s/PHPMYADMIN_IP/$phpmyadmin/g" ./srcs/form/nginx_w.conf > ./srcs/nginx/srcs/nginx.conf

docker build -t my-nginx srcs/nginx/ > /dev/null
kubectl set image deployment/nginx-deployment nginx=my-nginx:latest

echo "re done"
