minikube start --vm-driver=virtualbox
export MINIKUBE_IP=$(minikube ip)

### LoadBalancer START ###
minikube addons enable metallb    # kubelet get pods -n metallb-system
sed "s/MINIKUBE_IP/$MINIKUBE_IP/g" ./srcs/form/metallb.yaml > ./srcs/metallb/metallb.yaml
kubectl apply -f ./srcs/metallb/metallb.yaml # kubelet describe configmap config -n metallb-system
echo "End metallib"
### LoadBalancer END ###

sed "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/form/vsftpd.conf > srcs/ftps/vsftpd.conf

eval $(minikube docker-env)

echo "Docker building ..."
docker build -t my-nginx srcs/nginx/ > /dev/null
echo "nginx END"
docker build -t my-ftps srcs/ftps/ > /dev/null
echo "ftps END"
docker build -t my-mysql srcs/mysql_wordpress_phpMyAdmin/mysql > /dev/null
echo "mysql END"
docker build -t my-wordpress srcs/mysql_wordpress_phpMyAdmin/wordpress > /dev/null
echo "wordpress END"
docker build -t my-phpmyadmin srcs/mysql_wordpress_phpMyAdmin/phpMyAdmin > /dev/null
echo "phpMyAdmin END"
docker build -t my-influxdb srcs/influxdb_grafana/influxdb > /dev/null
echo "influxdb END"
docker build -t my-telegraf srcs/telegraf > /dev/null
echo "telegraf END"
docker build -t my-grafana srcs/influxdb_grafana/grafana > /dev/null
echo "grafana END"

echo "Apply yaml ..."
kubectl apply -k srcs/yaml

echo "get external ip"
wordpress=$(kubectl describe svc wordpress-service | grep "LoadBalancer Ingress" | cut -f 2 -d ':' | tr -d ' ')
phpmyadmin=$(kubectl describe svc phpmyadmin-service | grep "LoadBalancer Ingress" | cut -f 2 -d ':' | tr -d ' ')

echo "process re nginx"
sed "s/WORDPRESS_IP/$wordpress/g" ./srcs/form/nginx.conf > ./srcs/form/nginx_w.conf
sed "s/PHPMYADMIN_IP/$phpmyadmin/g" ./srcs/form/nginx_w.conf > ./srcs/nginx/srcs/nginx.conf

docker build -t my-nginx srcs/nginx/ > /dev/null
kubectl set image deployment/nginx-deployment nginx=my-nginx:latest

echo "re done"