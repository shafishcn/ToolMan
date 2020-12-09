## 零、安装
- docker
```
https://docs.docker.com/engine/install/
```

- dockerCompose
```shell
sudo pip3 install docker-compose
sudo yum upgrade python*
docker-compose version
# 卸载命令
sudo pip uninstall docker-compose
```

## 一、docker名词说明
- 镜像image
相当于Java中的类文件，dockers可以通过镜像来创建多个不同的容器。

- 容器container
相当于小型的Linux系统，通过镜像可以创建一个或一组不同的系统，容器可以启动、停止、删除等

- 仓库repository
存放镜像的地方，共有+私有。

## 二、镜像
- 1.查看本地镜像：`docker images`；
- 2.查看镜像的详细信息：`docker images --help`；
- 3.搜索镜像：`docker search 镜像名称`，可以--help查看具体的用法，比如搜索stars>200的镜像：`docker search mysql --filter=STARS=300`；
- 4.下载镜像：`docker pull 镜像:版本`；版本需要去官网上找，存在才能下载成功；
- 5.删除镜像：`docker rmi 镜像id/名称`，删除全部镜像（Linux中可用）：`docker rmi -f $(docker images -q)`；

## 三、容器
- 1.新建容器并启动：`docker run [args] imageid/name`
    - `--name="名称"`：指定新建启动容器的名称
    - `-d`：后台方式运行
    - `-it`：使用交互方式运行进入该容器，需要在后面指定交互的shell，比如`/bin/bash`
    - `-p`：指定容器的端口映射，比如`-p 主机端口:容器端口`-> `-p 8080:8080`，如果只是`-p`则随机端口
- 2.查看正在运行的容器：`docker ps`
    - `-a`：可以查看所有曾经运行的容器记录
    - `-n=num`：num指定最近创建的容器记录条数
    - `-q`：只显示容器的id，配合-a使用
- 3.退出容器(使用`-it`进入容器)：
    - `exit`：停止容器并退出
    - `ctrl+p+q`：不停止容器退出
- 4.删除容器：`docker rm 容器id`，删除所有容器（同上）：`docker rm $(docker ps -aq)`；`-f`强制删除所有容器，包括正在运行的容器。

- 5.停止/启动容器
    - `docker start 容器id`
    - `docker restart 容器id`
    - `docker stop 容器id`
    - `docker kill 容器id`

- 6.进入正在运行的容器
    - `docker exec -it 容器id /bin/bash`：进入容器开启一个新的终端
    - `docker attach 容器id`：进入容器正在执行的终端

### 扩展
- 1.后台运行容器，停止问题
```shell
docker run -d centos
docker ps
docker ps -a
```
> 后台运行必须要有一个前台进程应用，如果没有就会立刻停止容器。

- 2.日志
`docker logs [OPTIONS] 容器id`：查看容器的日志信息。
options：`-tf`显示有时间戳的日志；`--tail num`显示几条日志信息
```shell
docker logs -tf --tail 10 xxx
```

- 3.查看容器中的进程信息：`docker top 容器id`

- 4.查看容器本身的详细信息（源数据）：`docker inspect 容器id`

- 5.拷贝容器中的文件到物理机上：`docker cp 容器id:/资源完整路径 物理机路径`，比如拷贝某容器中的fish.java到物理机当前路径中。

- 6.查看docker相关cpu信息：`docker stats 容器id`
```
docker run -it --name="centos" centos /bin/bash
cd /home
touch fish.java
# ctrl+p+q或者exit退出该容器
docker ps # 查看容器id
docker cp cae59371ee6d:/home/fish.java ./
```

## 四、例子
- 1.安装ngix镜像
```shell
docker search nginx # https://hub.docker.com/_/nginx
docker pull nginx
docker run -d --name="fishNgix" -p 3344:80 nginx # -d后台启动、-p 本地物理机端口:ngix容器端口
curl http://localhost:3344
```
ok，你就会看到nginx默认返回内容。

- 2.安装tomcat镜像
```shell
docker run -it --name="fishTomcat" -p 3355:8080 tomcat /bin/bash
cp -r webapps.dist/* webapps
```
ok，访问本地`localhost:3355`即可。

- 3.安装es
```shell
docker run -d --name="fishElasticsearch" -p 9200:9200 -p 9300:9300 -e "descovery.type=single-node" -e ES_JAVA_OPTS="-Xms64m -Xmx512m" elasticsearch:7.6.2
# -e表示配置环境
``` 


## 五、辅助
- 可视化面板`portainer`
`docker run -d -p 8088:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock --privileged=true portainer/portainer`

## 六、镜像文件说明
> docker镜像使用的时层级文件系统来记录修改。
- 比如说一个我们下载（pull）的`centos`就是一个基本的单个文件，但是我们下载`nginx`镜像时会下载好几个文件。这是为什么
- 在docker中这些文件都是可重用的，对一个基本的镜像文件添加了某些功能，它就形成了一个新的镜像，这里的功能可以理解为模块。
- 我们再下载别的镜像时，如果本地已经存在新镜像包含的模块，就不会下载该模块。

> 正是使用类似的思想，docker的镜像文件都会很小，而且用户也很方便添加新的模块，打包我们的应用程序到镜像中，直接在生产环境启动。
>> 这里的新模块也就是相比源镜像的变化，类似git，只要有不同就相当添加了新模块。

## 七、commit镜像

`docker commit -m="描述信息" -a="作者" 容器id 起一个打包的镜像名:版本`

以上面我们下载的`tomcat`为例子。
下载的官方tomcat镜像里默认webapps下是没有内容的，我们需要复制同目录下`webapps.dist`里的内容到`webapps`中，最后把这个有默认访问网页的本地容器打包成一个新的镜像。
- 1.先修改容器
```shell
# 首先删除我们的tomcat容器，再使用docker ps -a看看还有没有
docker rm 容器id/容器名称
# 启动官方的tomcat，访问本地localhost:8888，会发现页面404，不是tomcat的默认页面
docker run -it -p 8888:8080 tomcat
# 在容器中修改默认页面
先按ctrl+p+q退出该容器
# 重新进入 ,docker ps 看容器id
docker exec -it e0414b913e0c /bin/bash
cp -r webapps.dist/* webapps
# ok，此时本地localhost:8888刷新正常出现tomcat默认页面
```
- 2.再提交
```shell
docker ps # 容器id
docker commit -m="有默认页面的tomcat,看着舒服" -a="shafish" e0414b913e0c tomcatdefaultpage:0.1
# ok
docker images # 就可以看到在本地生成了一个tomcatdefaultpage镜像
```

## 八、挂载数据卷（Linux中有效）
提供数据（数据库/配置文件 etc）的外部存储和共享。需求就这么简单
### 第一种：外部存储（物理机-容器）
`-v 物理机目录:容器目录`
- 1.命令介绍：
```shell
# 把当前的docker目录与centos容器的/home目录设置同步
docker run -it -v ./docker:/home centos /bin/bash
docker ps # 获取id
docker inspect 容器id # 主要看"Mounts"节点信息，提示type为bind即表示绑定成功
```
现在就可以在物理机docker目录下创建一个文件，进入容器查看是否同步。
- 2.结合mysql实战一下：
设置mysql的配置文件和数据同步。
```shell
docker run -d -p 3310:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7
# -d后台运行 -p 端口映射 - v 物理机目录:容器目录 -e 配置环境（密码） 镜像名称:镜像tag
```
- 3.docker还可以不用指定物理机的目录，这种做法也称为`匿名挂载`。
```shell
# -P随机映射端口
docker run -d -P --name fish1 -v /etc/nginx:ro nginx
```
- 4.为`-v`指定一个挂载的名称，`具名挂载`。推荐使用
```shell
# 需要注意shafish前面并没有/ 说明这是一个挂载命名，不代表物理机目录
docker run -d -P --name fish2 -v shafishNginx:/etc/nginx:rw nginx
```
>> 命令中容器目录后面的ro/rw 是针对容器对目录内容`只读`和`可读写`的权限设置。不明白就自己跑一下
> 使用`docker volume ls`查看卷的挂载情况
>> 使用`docker volume inspect 具名挂载名称`查看容器目录挂载到物理机的位置。都位于：`/var/lib/docker/volumes/`下


- 5.也可以通过`Dockerfile`在构建镜像时指定挂载
`Dokerfile`可以通过命令构建一个镜像文件，直接指定`volume`挂载目录。在当前目录创建一个名字为`Dockerfile`文件
```
FROM centos
VOLUME ["volume1","volume2"]
CMD echo "====end==="
CMD /bin/bash
```
然后运行：
`docker build -f ./Dockerfile -t fisha/centos:1.0`
> Dockerfile文件命令都需要大写，每个命令都相当一个模块，在`docker build`时生成我们的docker镜像文件。
> `VOLUME ["volume1","volume2"]`就是匿名挂载，使用`docker inspect 镜像id`可以查看`mounts`节点挂载信息。

### 第二种：数据共享（容器-容器）`--volumes-from`
 ```shell
# 创建一个名称为docker01的容器，作为父类容器，让别的容器挂载
docker run -it --name docker1 fisha/centos:1.0
# 因为fisha/centos:1.0是上面第5步使用Dockerfile创建的镜像，包含两个挂载目录，
# 使用--volumes-from 把当前新建的容器的挂载目录同步到docker1的挂载目录中
docker run -it --name docker2 --volumes-from docker1 fisha/centos:1.0
# 现在在docker1容器中创建文件，就会发现docker2的挂载目录中会同步该文件。
# 在docker2中创建文件，docker1亦然
 ```
 - 例子：创建两个myslq容器，使用同一个数据库文件。
 ```shell
 # 父容器，指定容器内挂载目录为/etc/mysql/conf.d和/var/lib/mysql
docker run -d -p 3310:3306 -v /etc/mysql/conf.d -v /var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql1 mysql
# 子容器，同样指定挂载目录，同步父容器数据，使用--volumes-from挂载mysql1
docker run -d -p 3311:3306 -v /etc/mysql/conf.d -v /var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 --name mysql2 --volumes-from mysql1 mysql
 ```

 ## 九、Dockerfile
 构建镜像的脚本。
 ```shell
# 步骤
1. 编写镜像Dockerfile脚本
2. docker build构建成为一个镜像
3. docker run镜像
4. docker push 发布镜像
 ```
 ### 常用指令
 ```shell
 # FROM         指定基础镜像：centos等
 # MAINTAINER   表明构建本镜像的作者信息：姓名+邮箱
 # RUN          镜像构建时需要运行的命令
 # ADD          添加内容，比如说tomcat
 # WORKDIR      镜像的工作目录
 # VOLUME       挂载目录
 # EXPOST       端口配置
 # CMD          指定容器启动时默认运行的命令，如果用户在运行容器时编写了执行命令，就会覆盖CMD编写的命令
 # ENTRYPOINT   除了默认定义的命令，在容器启动时用户还可以在追加执行命令（apped）
 # ONBUILD      构建一个被继承的Dockerfile时，触发该命令
 # COPY         类型add，将文件拷贝到镜像中
 # ENV          构建时设置环境变量
 ```
 ### centos官方镜像
 ```shell
 FROM scratch  # 最基础的docker镜像，类似容器的启动引导命令
ADD centos-7-x86_64-docker.tar.xz /

LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="CentOS Base Image" \
    org.label-schema.vendor="CentOS" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20200504" \
    org.opencontainers.image.title="CentOS Base Image" \
    org.opencontainers.image.vendor="CentOS" \
    org.opencontainers.image.licenses="GPL-2.0-only" \
    org.opencontainers.image.created="2020-05-04 00:00:00+01:00"

CMD ["/bin/bash"]
 ```

### 例子1
我们就可以基于上面的centos镜像，在构建一个自己的镜像。
- 编写构建文件
```shell
FROM centos  # 源镜像，在cenos的基础上构建
MAINTAINER shafish<shafish_cn@163.com>  # 作者信息

ENV MYPATH /usr/local
WORKDIR $MYPATH     # 工作目录，-it进入容器时的当前目录

RUN yum -y install vim
RUN yum -y install net-tools

EXPOSE 80  # 暴露80端口

CMD echo $MYPATH
CMD echo "--end--"
CMD /bin/bash  # 容器启动后进入bash命令行
```
- 生成镜像
```shell
# -f dokcerfile目录 -t 生成的镜像名称:版本号 .
docker build -f ./Dockerfile1 -t fishcentos:1.0 .
```

- 查看镜像在本地的变更记录`docker history 镜像id`

### 例子2
CMD和ENTRYPOINT的区别。
> 使用`CMD`的Dockerfile2
```
FROM centos
CMD ["ls","-a"]
```
- 构建镜像：`docker build -f ./Dockerfile2 -t fishacentosls:1.0 .`
- 运行容器：
    - CMD命令替换：`docker run fishacentosls:1.0 -lsh`，会发现-l命令提示错误，这是因为用户自定义的-l替换了`CMD ["ls","-a"]`的内容，直接变成了`CMD -l`
    - CMD完整使用命令：`docker run fishacentosls:1.0 ls -lsh`

> 使用`ENTRYPOINT`的Dockerfile3
```
FROM centos
ENTRYPOINT ["ls","-a"]
```
- 构建镜像：`docker build -f ./Dockerfile3 -t fishcentosls2:1.0 .`
- 运行容器：
    - 用户命令直接追加：`docker run fishcentosls2:1.0 -lsh`

### 例子3 tomcat
> Dockerfile构建文件
```shell
FROM centos
MAINTAINER shafish<shafish_cn@163.com>

COPY readme.md /usr/local/readme.md

ADD apache-tomcat-9.0.35.tar.gz /usr/local
ADD jdk-8u251-linux-x64.tar.gz /usr/local

RUN yum -y install vim

ENV MYPATH /usr/local
WORKDIR $MYPATH

ENV JAVA_HOME /usr/local/jdk1.8.0_251
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.35
ENV CATALINA_BASH /usr/local/apache-tomcat-9.0.35
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin

EXPOSE 8080

CMD /usr/local/apache-tomcat-9.0.35/bin/startup.sh && tail -F /usr/local/apache-tomcat-9.0.35/logs/catalina.out
```

> 镜像生成
```
docker build -t fisahjavapro:1.0 .
```
使用`docker images`就可以看到本地有一个fisahjavapro的镜像了

> 容器启动
```
Docker run -d -p 8081:8080 --name fishajavaprodu -v ./test:/usr/local/apache-tomcat-9.0.35/webapps/test -v ./test/log/:/usr/local/apache-tomcat-9.0.35/logs fisahjavapro:1.0
```

> 下一步直接把项目放在test目录中即可运行项目

## 发布镜像
- 发布到官方hub镜像仓库：`https://hub.docker.com/`注册个账号
```shell
# docker tag firstimage YOUR_DOCKERHUB_NAME/firstimage
docker tag fishajavaenv shafish/fishajavaenv
# docker push YOUR_DOCKERHUB_NAME/firstimage
docker push shafish/fishajavaenv
```
- 发布到阿里云镜像仓库
容器镜像服务（基操）：https://cr.console.aliyun.com/cn-hangzhou/instances/repositories

![](https://cdn.shafish.cn/imgs/docker/docker.png)


## jellyfin更新

docker run -d --name=jellyfin --env=PGID=1000 --env=TZ=Europe/London --env=PUID=1000 --env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --env=HOME=/root --env=LANGUAGE=en_US.UTF-8 --env=LANG=en_US.UTF-8 --env=TERM=xterm --env=NVIDIA_DRIVER_CAPABILITIES=compute,video,utility --volume=/data/jellyfin/config:/config --volume=/data/jellyfin/cache:/cache --volume=/mnt:/data/veracrypt --volume=/config -p 8096:8096 --expose=8920 --restart=unless-stopped linuxserver/jellyfin

## 查看docker运行容器的启动命令
runlike:https://blog.csdn.net/qq_35462323/article/details/101607062

## 本地磁力资源下载
docker run --name cloudTorrent -d -p 4000:3000 -v /mnt/veracrypt9/cloudTorrent:/downloads --restart=unless-stopped  jpillora/cloud-torrent

docker run --name simpleTorrent -d -p 4000:3000 -v /data/cloudTorrent/downloads:/downloads -v /data/cloudTorrent/torrents:/torrents --restart=unless-stopped boypt/cloud-torrent --port 3000 -a graham:xxxx

## Jenkins
```
sudo mkdir -p /var/data/jenkins_home

docker run -u root -d -p 10240:8080 -p 10241:50000 \
-v /var/data/jenkins_home:/var/jenkins_home \
-v /opt/jdk8u272-ga:/usr/local/jdk1.8 \
-v /opt/apache-maven-3.6.3:/usr/local/maven3 \
-v /usr/bin/git:/usr/bin/git \
-v /etc/localtime:/etc/localtime \
-v /var/run/docker.sock:/var/run/docker.sock \
--privileged=true --restart=always --name myjenkins jenkinsci/blueocean
```

- 修改加速：/var/data/jenkins_home/hudson.model.UpdateCenter.xml
```xml
<?xml version='1.1' encoding='UTF-8'?>
<sites>
  <site>
    <id>default</id>
    <url>https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json</url>
  </site>
</sites>
```
- 查看登录密码：docker logs myjenkins或者cat /var/data/jenkins_home/secrets/initialAdminPassword

> 如果登录提示offine，则修改加速后再访问xxx:10240/restart或者参考下面 网络问题 步骤解决

## 网络问题
```shell
# wget https://cdn.shafish.cn/bridge-utils-1.6.tar.xz
tar -xf bridge-utils-1.6.tar.xz
cd bridge-utils-1.6
yum install autoconf
autoconf
./configure --prefix=/usr
make
make install
```
```shell
systemctl start firewalld #启动防火墙服务
firewall-cmd --add-masquerade --permanent     ##开启IP地址转发（一直生效）
firewall-cmd --reload         ##重载防火墙规则，使之生效
```
```shell
systemctl stop docker
iptables -t nat -F POSTROUTING
ip link set dev docker0 down
brctl delbr docker0
systemctl start docker
```

## 短地址生成
https://www.moerats.com/archives/956/

docker run --restart=always --name lstu -d -p 8080:8080 -v "$(pwd)/lstu.conf:/home/lstu/lstu.conf" -v "$(pwd)/lstu.db:/home/lstu/lstu.db" lstu

## fiora
docker pull mongo
docker pull suisuijiang/fiora
docker network create fiora-network
docker run --name fioradb -d -p 27017:27017 --network fiora-network mongo
docker run --name fiora -d -p 7799:7799 -v /opt/fiora/config/:/usr/app/fiora/fisha/  --network fiora-network -e Database=mongodb://fioradb:27017/fiora suisuijiang/fiora
```shell
# 在/opt/fiora/config目录下创建.env文件，内容如下：
DefaultGroupName=tffats
DisableCreateGroup=true
DisableDeleteMessage=true
Port=7799
JwtSecret=xxxdsdaeqtqf
DisableRegister=true
```

```shell
# 进入fiora容器启动复制配置文件到fiora根目录中
docker exec -it fiora /bin/bash
# 复制fisha目录下的.env到fiora根目录
cp fisha/.env ./
# 退出，重启
exit
docker restart fiora
```
- 设置管理员
    - `yarn script getUserId [username]`
    - Administrator=xxid
- 手动注册新用户
    - `yarn script register [username] [password]`

- 删除
    - `yarn script deleteUser [id]`5fca63cf7bbce3001dfa3afb

## 去广告adguardhome
docker run --name adguardhome -v /data/adguardhome/work:/opt/adguardhome/work -v /data/adguardhome/conf:/opt/adguardhome/conf -p 53:53/tcp -p 53:53/udp -p 67:67/udp -p 68:68/tcp -p 68:68/udp -p 80:80/tcp -p 443:443/tcp -p 853:853/tcp -p 3000:3000/tcp -d --restart=unless-stopped adguard/adguardhome

