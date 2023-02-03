## ~~宿主ip映射~~
|  宿主ip   | 网卡(ip addr) | 容器ip  |
|  :----:  | :----:| :----:  |
| 192.168.0.161  |eth0@if61| 172.23.0.5 |
| 192.168.0.162  |eth0@if65| 172.23.0.6 |
| 192.168.0.163  |eth0@if69| 172.23.0.7 |


## ~~docker容器内跨主机通信~~
``` sh
# 192.168.0.161
docker network create -d macvlan --subnet=192.168.0.0/24 --gateway=192.168.0.125 -o parent=eth0@if61 cross-host-net
# 192.168.0.162
docker network create -d macvlan --subnet=172.23.0.0/24 --gateway=172.23.0.1 -o parent=eth0@if65 cross-host-net
# 192.168.0.163
docker network create -d macvlan --subnet=172.23.0.0/24 --gateway=172.23.0.1 -o parent=eth0@if69 cross-host-net
```

## 一、环境安装
### Zookeeper集群部署
> docker-compose.yml

``` yml
# master
version: '3.3'
services:
    zookeeper:
        container_name: zookeeper-master # zookeeper-slave1 zookeeper-slave2
        restart: unless-stopped
        ports:
            - '2181:2181'
            - '2888:2888'
            - '3888:3888'
            - '8080:8080'
        volumes:
            - '/data/docker/zookeeper/conf:/conf'
            - '/data/docker/zookeeper/data:/data'
            - '/data/docker/zookeeper/datalog:/datalog'
            - '/data/docker/zookeeper/logs:/logs'
        image: zookeeper:3.6
```

> 修改节点标识

``` shell
# master
echo 1 > /data/docker/zookeeper/data/myid
# slave1
echo 2 > /data/docker/zookeeper/data/myid
# slave2
echo 3 > /data/docker/zookeeper/data/myid
```

> 节点关联(本节点ip需要修改为0.0.0.0)

``` shell
# master
vim /data/docker/zookeeper/conf/zoo.cfg
```
``` conf
dataDir=/data
dataLogDir=/datalog
tickTime=2000
initLimit=5
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=0
maxClientCnxns=60
standaloneEnabled=true
admin.enableServer=true
server.1=0.0.0.0:2888:3888;2181
server.2=192.168.0.162:2888:3888;2181
server.3=192.168.0.163:2888:3888;2181
```

``` shell
# slave1
vim /data/docker/zookeeper/conf/zoo.cfg
```
``` conf
dataDir=/data
dataLogDir=/datalog
tickTime=2000
initLimit=5
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=0
maxClientCnxns=60
standaloneEnabled=true
admin.enableServer=true
server.1=192.168.0.161:2888:3888;2181
server.2=0.0.0.0:2888:3888;2181
server.3=192.168.0.163:2888:3888;2181
```

``` shell
# slave2
vim /data/docker/zookeeper/conf/zoo.cfg
```
``` conf
dataDir=/data
dataLogDir=/datalog
tickTime=2000
initLimit=5
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=0
maxClientCnxns=60
standaloneEnabled=true
admin.enableServer=true
server.1=192.168.0.161:2888:3888;2181
server.2=192.168.0.162:2888:3888;2181
server.3=0.0.0.0:2888:3888;2181
```

### Kafka集群部署
``` yml
version: "3"
services:
    kafka:
        container_name: kafka-master # kafka-slave1 kafka-slave2
        image: 'bitnami/kafka:3.3'
        user: root
        ports:
            - '9092:9092'
        volumes:
            - '/data/docker/kafka:/bitnami/kafka'
        environment:
            - KAFKA_BROKER_ID=1 # 2 3
            - KAFKA_CFG_LISTENERS=PLAINTEXT://0.0.0.0:9092
            - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://192.168.0.161:9092 # 162 163
            - KAFKA_CFG_ZOOKEEPER_CONNECT=192.168.0.161:2181,192.168.0.162:2181,192.168.0.163:2181
            - ALLOW_PLAINTEXT_LISTENER=yes
```

## 二、测试
### 安装jdk11
``` shell
cd /opt
```
``` shell
wget https://open.cdn.shafish.cn/jdk-11.0.17_linux-x64_bin.tar.gz
tar -zxvf jdk-11.0.17_linux-x64_bin.tar.gz
vim /etc/profile.d/jdk.sh
source /etc/profile.d/jdk.sh
```

``` shell
export JAVA_HOME=/opt/jdk-11.0.17
export PATH=$PATH:$JAVA_HOME/bin
```

### 安装kafka命令
``` shell
wget https://downloads.apache.org/kafka/3.3.2/kafka_2.13-3.3.2.tgz
tar -zxvf kafka_2.13-3.3.2.tgz
kafka_2.13-3.3.2/bin/kafka-topics.sh --create --bootstrap-server 192.168.0.161:9092 --replication-factor 3 --partitions 1 --topic test-ken-io
# 是否提示重复
kafka_2.13-3.3.2/bin/kafka-topics.sh --create --bootstrap-server 192.168.0.162:9092 --replication-factor 3 --partitions 1 --topic test-ken-io
# 是否提示重复
kafka_2.13-3.3.2/bin/kafka-topics.sh --create --bootstrap-server 192.168.0.163:9092 --replication-factor 3 --partitions 1 --topic test-ken-io
```

## 三、应用

### kafka-topic.sh
> 创建一个新主题，该主题存在3个分区，每个分区存在2个副本

``` shell
kafka_2.13-3.3.2/bin/kafka-topics.sh --create --bootstrap-server 192.168.0.162:9092 --replication-factor 2 --partitions 3 --topic test-ken-io
```
- `bootstrap-server`：kafka broker节点（填部分节点就行）
- `create`：创建主题
- `partitions`：该主题划分的分区数量
- `replication-factor`：分区副本数量
- `replica-assignment`：副本分配方案
- `alter`：变更主题
- `config`：修改主题相关配置
- `delete`：删除主题
- `list`：列出有效主题
- `describe`：查询主题详细信息

``` shell
kafka_2.13-3.3.2/bin/kafka-topics.sh --describe --bootstrap-server 192.168.0.162:9092 --topic test-ken-io
#Topic: test-ken-io      TopicId: qG6YjyvwRxak0sFPN208XA PartitionCount: 1       ReplicationFactor: 3    Configs: 
#Topic: test-ken-io      Partition: 0    Leader: 1       Replicas: 1,2,3 Isr: 2,3,1
```

### kafka-console-producer.sh
> 给指定主题发送消息

``` shell
cd /opt/kafka_2.13-3.3.2
./bin/kafka-console-producer.sh --bootstrap-server 192.168.0.162:9092 --topic test-ken-io
```

### kafka-console-consumer.sh
> 消费指定主题消息

``` shell
./bin/kafka-console-consumer.sh --bootstrap-server 192.168.0.162:9092 --topic test-ken-io --group test-group --from-beginning
```
- group：指定消费组

### kafka-consumer-groups.sh
> 查看指定消费组信息

``` shell
./bin/kafka-consumer-groups.sh --bootstrap-server 192.168.0.162:9092 --describe --group test-group
```