## 一、安装
``` shell
cd /opt
wget https://github.com/fatedier/frp/releases/download/v0.51.3/frp_0.51.3_linux_amd64.tar.gz
tar zxvf frp_0.51.3_linux_amd64.tar.gz
cd frp_0.51.3_linux_amd64
```

## 二、frps配置
### frps.ini
``` shell
vim frps.ini
```

``` "frps.ini"
[common]
bind_port = 7000 // 运行端口
token = 22BxxxxxJ // 连接token
dashboard_port = 1100 // 后台面板端口
dashboard_user = xxxh // 后台面板登录用户
dashboard_pwd = fxxxxd8 // 后台面板登录用户密码
vhost_http_port = 7086 // 域名http访问端口
vhost_https_port = 7088 // 域名https访问端口
subdomain_host = shafish.cn // 域名demain
enable_prometheus = true
log_file = /var/log/frps.log
log_level = info
log_max_days = 3
```

### frps.service
``` shell
vim frps.service
```

``` "frps.service"
[Unit]
Description = frp server
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
ExecStart = /opt/frp_0.51.3_linux_amd64/frps -c /opt/frp_0.51.3_linux_amd64/frps.ini
ExecReload = /opt/frp_0.51.3_linux_amd64/frps reload -c /opt/frp_0.51.3_linux_amd64/frps.ini
ExecStop = /bin/kill $MAINPIN
Restart = on-failure
RestartSec = 5

[Install]
WantedBy = multi-user.target
```

### 启动
``` shell
cp frps.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable frps
systemctl start frps
systemctl status frps
```

## 三、frpc配置
### frpc.ini
``` "frpc.ini"
[common]
server_addr = x.x.x.x
server_port = 7000 // 运行端口
token = 22BxxxxxJ // 连接token
log_file = /var/log/frps.log
log_level = info
log_max_days = 3
includes = /home/shafish/Software/frp_0.51.3_linux_amd64/confd/*.ini
```

``` "confd/ssh.ini"
[amd-ssh]
type = stcp
local_ip = 127.0.0.1
local_port = 22
sk = amd-xx-ssh-token
```

``` "confd/nomachine.ini"
[amd-nomachine]
type = stcp
local_ip = 127.0.0.1
local_port = 4000
sk = amd-!#$@%^fdafiewofnaofwo12398467-nomachine-token
```