# Wireguard Easy
该项目可以帮助您在Docker中启动Wireguard VPN服务器，并提供简单的脚本来配置服务器参数。

# 安装要求
- Docker
- Bash Shell

# 使用方法
克隆该项目到本地：
```
git clone https://github.com/xubiaolin/docker-wireguard-easy.git
```

进入项目目录：`cd docker-wireguard-easy`
运行脚本：`./run.sh`

按照提示输入服务器参数：`IPv4`地址或域名、管理员密码等。
脚本会启动Wireguard VPN服务器，并将配置文件挂载到本地目录data/etc/wireguard中。

# 注意事项
- 请确保所使用的IPv4地址或域名可以从公网访问到您的服务器。
- 管理员密码不可为空，否则脚本将退出。

本项目默认使用的Wireguard VPN服务器IP地址为10.0.8.x，默认DNS为223.5.5.5和223.6.6.6。
如需修改服务器参数，请修改脚本中的相关变量。

本项目默认使用端口51820/udp和51821/tcp，请确保这些端口未被占用。
该脚本需要在root权限下运行。

# 许可证
该项目使用MIT许可证，详情请参阅LICENSE文件。
