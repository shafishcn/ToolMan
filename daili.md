Trojan更新到最新版本，偶然看到个带web的一键安装脚本，mark。（web还是一键，web！（明明是一键））

## 一、安装centos7系统
vps厂商图形化创建系统，选择centos7并记录ssh登录密码即可。`ssh root@ip -p`

## 二、安装前的设置
### 1. yum更新问题
- 使用`yum update`时提示`Loaded plugins: fastestmirror`还有什么`xxxyum lock`。
- 解决：
    - vi  /etc/yum/pluginconf.d/fastestmirror.conf 将enable=1改为enable=0
    - vi /etc/yum.conf 将plugins=1改为plugins=0
    - yum clean all
    - rm -rf /var/cache/yum
    - yum makecache
    - ok

### 2. 环境准备命令
```bash
yum update
yum upgrade
yum install -y vim wget
// 选择安装bbr plus加速，先卸载全部加速9，再重新选择加速内核2，重启后再选择加速模板7
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
// docker大法好用
yum install docker -y
systemctl start docker
```

> 如果安装docker后，运行docker相关命令提示:`Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?`
>> 直接重启docker即可：
```service restart docker```

![](https://down.shafish.cn/study/trojan/bbrplus.png)


<!--more-->


## 三、trojan安装相关命令
> 新版使用了关系型数据库-存储用户数据，可以管理用户流量信息。so，还要安装数据库，Linux选择安装`mariadb`数据库！！（没有特别原因）

>> 一键搭建参考：https://github.com/Jrohy/trojan

### 1. 安装并运行docker mariadb数据库容器
```bash
docker run --name trojan-mariadb --restart=always -p 3306:3306 -v /home/mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=trojan -e MYSQL_ROOT_HOST=% -e MYSQL_DATABASE=trojan -d mariadb:10.2
```
- 命令解释：从docker仓库拉取了mariadb镜像并启动了容器，映射了本地端口和共享目录等，设置了mariadb密码`trojan`（这个重要，后面需要用到）

### 2. 安装并运行Jrohy提供的trojan镜像容器
```bash
docker run -it -d --name trojan --net=host --restart=always --privileged jrohy/trojan init
```
ok! 
现在使用`docker ps`命令就可以看到vps有两个正在运行的容器了。

> 如果下面第3节的Trojan设置崩了，可以简单粗暴地直接删除该trojan镜像，再重新拉取，重新设置！！`停止Trojan容器`及`删除Trojan镜像`命令如下：
```bash
// 查看正在运行的容器，主要是获取Trojan容器的`CONTAINER ID`，再stop停掉
docker ps
docker stop xxxxx(容器id)
// 获取镜像id，再删掉
docker images
docker rmi 镜像id
// 再拉取
docker run -it -d --name trojan --net=host --restart=always --privileged jrohy/trojan init
// 过程遇到问题，自行搜索。
```

![](https://down.shafish.cn/study/trojan/dockerps.png)

![](https://down.shafish.cn/study/trojan/stop.png)

### 3. Trojan容器的设置
准备工作都做好了，下面正式开干！！
- 3.1. 进入trojan容器
```bash
docker exec -it trojan bash
```

- 3.2. 安装trojan程序
    - 直接在命令行输入trojan
    ```bash
    trojan
    ```
    - 选择`1.Let's Encrypt 证书`，要折腾的也可以自定义证书；
    - 输入绑定vps ip的域名；（基本要求）
    - 安装成功后，提示需要设置mysql连接。（如果docker run mariadb时没有修改密码，默认为trojan）
    ```bash
    请输入mysql连接地址(格式: host:port), 默认连接地址为127.0.0.1:3306, 使用直接回车, 否则输入自定义连接地址:
    请输入mysql root用户的密码: trojan
    重启trojan成功!
    ```
    - ok

- 3.3. trojan的设置
> 套路跟Jrohy的v2ray是一样的。
> 6个选项都是字面上的意思。选择5，获取链接，输入到手机`lgniter`上测试能不能用。
```bash
欢迎使用trojan管理程序
1.trojan管理            2.用户管理
3.安装管理              4.web管理
5.查看配置              6.生成json
请选择: 1
1.启动trojan
2.停止trojan
3.重启trojan
4.查看trojan状态
请选择: 4
● trojan.service - trojan
   Loaded: loaded (/etc/systemd/system/trojan.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2020-04-24 15:24:28 UTC; 12s ago
     Docs: https://trojan-gfw.github.io/trojan/config
           https://trojan-gfw.github.io/trojan/
 Main PID: 2272 (trojan)
   CGroup: /system.slice/docker-9e46e01dc131d216a52c970b0d91xxx744d840c2f63.scope/system.slice/trojan.service
           └─2272 /usr/bin/trojan/trojan /usr/local/etc/trojan/config.json
Apr 24 15:24:28 UnwittingEnvious-VM systemd[1]: Stopped trojan.
Apr 24 15:24:28 UnwittingEnvious-VM systemd[1]: Started trojan.
Apr 24 15:24:28 UnwittingEnvious-VM trojan[2272]: Welcome to trojan 1.15.1
Apr 24 15:24:28 UnwittingEnvious-VM trojan[2272]: [2020-04-24 15:24:28] [INFO] connecting to MySQL server 127.0.0.1:3306
Apr 24 15:24:28 UnwittingEnvious-VM trojan[2272]: [2020-04-24 15:24:28] [INFO] connected to MySQL server
Apr 24 15:24:28 UnwittingEnvious-VM trojan[2272]: [2020-04-24 15:24:28] [WARN] trojan service (server) started at 0.0.0.0:443
```

- 3.4. 启动用户管理界面
> 这个是Jrohy一键Trojan脚本的亮点，可以图形化监听用户流量使用情况。（毕竟都用了mariadb还有vue）
```bash
systemctl start trojan-web
systemctl enable trojan-web
```
OK，现在访问`https://你上面用的域名`看看。
![四不四很nice](https://down.shafish.cn/study/trojan/web.png)

- 3.5. 退出Trojan容器，关闭ssh连接
撒花 *★,°*:.☆（￣▽￣）/$:*.°★* 。下面就退出命令行，开始在手机或者电脑上设置Trojan吧

```bash
// 两个exit结束与vps的连接
exit
exit
```

## 四、设备使用Trojan
> 假设上面第三章中获取信息如下：
- 域名是：tj1.gotosky.monster
- 账号密码是：goToSky drop321
- 分享链接是：trojan://drop321@tj1.gotosky.monster:443

这里只分享软件下载，具体操作：略。

### 1. android
https://github.com/trojan-gfw/igniter
最新版可以导入分享链接了，直接把链接填入即可。

### 2. ios
https://apps.apple.com/us/app/shadowrocket/id932747118
略，但可参考[  ~第五版~  ](https://down.shafish.cn/%E5%B7%A5%E5%85%B7/%E7%A7%91%E6%8A%80%E4%B8%8A%E7%BD%91/Trojan/Trojan%E7%94%B5%E8%84%91%E5%92%8C%E6%89%8B%E6%9C%BA%E7%AB%AF%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E%E7%AC%AC%E4%BA%94%E7%89%88.docx)



### 3. 电脑端
https://github.com/TheWanderingCoel/Trojan-Qt5/releases

> 如果有配合v2ray使用的情况，可以直接下载 `https://github.com/trojan-gfw/trojan/releases` 中对应系统的压缩包；
- 更改`config.json`文件中的`remote_addr`和`password`，创建`start.bat`后台运行trojan.exe（看下面代码创建start.bat）；
- 然后右键`start.bat`发送到`桌面快捷方式`，把这个快捷方式丢到启动目录中（win+r输入shell:startup）；
- 最后使用v2rayn代理本地`socks://127.0.0.1:1080`即可。

```shell
@ECHO OFF
%1 start mshta vbscript:createobject("wscript.shell").run("""%~0"" ::",0)(window.close)&&exit
start /b xxx\trojan.exe
```
- 需要你指定`trojan.exe`所在的路径：xxx（绝对路径，相对路径都可以，双击能运行start.bat就行）

![](https://down.shafish.cn/study/trojan/config.png)

完结撒花 *★,°*:.☆（￣▽￣）/$:*.°★* 