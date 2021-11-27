## 一、docker安装
https://docs.docker.com/engine/install/

## 二、开启远程访问
- 配置开启ip、端口
`  sudo vim /usr/lib/systemd/system/docker.service`
```shell
# 在Service资源块的ExecStart末端加入  -H tcp://0.0.0.0:2375
...
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock -H tcp://0.0.0.0:2375
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
...
```
- 重启生效
`systemctl daemon-reload`
`systemctl restart docker`
- 防火墙开端口（如果开启了防火墙）
`firewall-cmd --zone=public --add-port=2375/tcp --permanent`
- 检查是否可用
`telnet 127.0.0.1 2375`

## 三、idea配置docker
- idea安装dokcer插件
![](./imgs/idea-docker1.png)

- 配置连接
api url为：tcp://docker所在服务器ip:2375，如果是本地则127.0.0.1
![](./imgs/idea-docker2.png)

- 检查
如果连接成功，可以展示docker中运行的所有容器和存在的镜像等信息
![](./imgs/idea-docker3.png)

## 创建项目使用docker运行
参考：
https://mp.weixin.qq.com/s/Ra9tILYgcIYrdeo2IqESVg
