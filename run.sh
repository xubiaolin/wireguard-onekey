#!/bin/bash

read -p "是否自动获取公网IP地址？（y/n）" use_auto_ip
if [[ "$use_auto_ip" =~ ^[Yy]$ ]]; then
    ipv4=$(curl -s https://ipv4.icanhazip.com/)

    echo "获取到的IPv4地址为: $ipv4"
    read -p "是否使用上面获取到的IP地址？（y/n）" use_auto_ip_result

    if [[ "$use_auto_ip_result" =~ ^[Nn]$ ]]; then
        read -p "请输入IPv4地址或者域名: " ipv4
    fi
else
    read -p "请输入IPv4地址或者域名: " ipv4
fi

read -p "请输入管理后台密码:" PASSWORD
if [ -z "$PASSWORD" ]; then
    echo "密码为空，退出"
    exit 1
fi

read -p "请输入管理后台访问端口:" TCP_PORT
if [ -z "$TCP_PORT" ]; then
    echo "管理后台访问为空，退出"
    exit 1
fi

echo "--------------------"
echo "ipv4或者域名：$ipv4"
echo "web登录的密码：$PASSWORD"
echo "--------------------"

echo "Do you want to continue? (y/n)"
read answer

if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
    echo "Continuing..."
else
    echo "Exiting..."
    exit 0
fi

docker run -d \
    --name=wg-easy \
    -e WG_HOST=$ipv4 \
    -e PASSWORD=$PASSWORD \
    -e WG_DEFAULT_ADDRESS=10.0.8.x \
    -e WG_DEFAULT_DNS=223.5.5.5,223.6.6.6 \
    -e WG_ALLOWED_IPS=10.0.8.0/24 \
    -e WG_PERSISTENT_KEEPALIVE=25 -v $(pwd)/data/etc/wireguard:/etc/wireguard \
    -e WG_PORT=$TCP_PORT\
    -p $TCP_PORT:51820/udp \
    -p $TCP_PORT:51821/tcp \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
    --sysctl="net.ipv4.ip_forward=1" \
    --restart unless-stopped \
    weejewel/wg-easy

if [ $? -ne 0 ]; then
    echo "failed to start"
    exit 1
fi

echo "--------------------"
echo "your admin url：http://$ipv4:$TCP_PORT"
echo "enjoy~"

