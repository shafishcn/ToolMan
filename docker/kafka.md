[toc]

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

## 零、概念
> 在完成一、二、三步骤后，对照kafka-ui界面再重复阅读！！

- `消息`：数据实体;
- `生产者`：发布消息的应用;
- `消费者`：订阅消息的应用;（不同消费者之间消费消息互不干预）
- `主题`：消息的逻辑分组，可以当成消息的分类;（不同主题消息互不干预）
- kafka`消费组`：多个消费者组成的一个逻辑分组;
- `broker`：kafka服务节点，负责接收、存储生产者发送的消息，并将消息投递给消费者;
- `分区`（分片Partitions）：一个或多个分区组成一个主题，主题消息可以划分给不同分区，并将不同的分区存储到不同的broker中，实现分布式存储;（每个分区都有对应的下标）
- `副本`（Replicas）：每个分区都有一个或多个副本，其中1个leader,0或多个follow副本，每个副本都保存了该分区的全部数据。（kafka将一个分区的不同副本保存到不同broker中，保证数据安全）
- `ISR`（In Sync Replicas）：分区中与leader副本数据保持一定程度同步的副本集;（该集合也包括leader副本本身）
- `ACK机制`：生产者发送消息成功的响应处理;消费者消费成功的响应处理;
- `ACK偏移量`：消息在主题中的偏移量offset
- `Zookeeper`：存储主题、分区等数据，并完成broker节点监控、controller选举等工作。

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
        restart: unless-stopped
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

### ~~kafka-manager~~
``` yml
version: '3.6'
services:
  kafka_manager:
    container_name: kafka-manager
    image: hlebalbau/kafka-manager:stable
    restart: unless-stopped
    ports:
      - "9000:9000"
    environment:
      ZK_HOSTS: "192.168.0.161:2181"
      APPLICATION_SECRET: "random-secret"
```

### kafka-ui
``` yml
version: '2'
services:
  kafka-ui:
    image: provectuslabs/kafka-ui
    container_name: kafka-ui
    ports:
      - "8081:8080"
    restart: unless-stopped
    environment:
      - KAFKA_CLUSTERS_0_NAME=local
      - KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=192.168.0.161:9092
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
# zk 命令
kafka_2.13-3.3.2/bin/zookeeper-shell.sh 192.168.0.161:2181
```

## 三、应用
### 1.脚本
#### kafka-topic.sh
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

#### kafka-console-producer.sh
> 给指定主题发送消息

``` shell
cd /opt/kafka_2.13-3.3.2
./bin/kafka-console-producer.sh --bootstrap-server 192.168.0.162:9092 --topic test-ken-io
```

#### kafka-console-consumer.sh
> 消费指定主题消息

``` shell
./bin/kafka-console-consumer.sh --bootstrap-server 192.168.0.162:9092 --topic test-ken-io --group test-group --from-beginning
```
- group：指定消费组

#### kafka-consumer-groups.sh
> 查看指定消费组信息

``` shell
./bin/kafka-consumer-groups.sh --bootstrap-server 192.168.0.162:9092 --describe --group test-group
```

#### kafka-configs.sh
动态配置

### 2.客户端
#### Java
``` xml
<dependency>
  <groupId>org.apache.kafka</groupId>
  <artifactId>kafka-clients</artifactId>
  <version>3.3.2</version>
</dependency>
```

``` java
public class BasicProducer {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        Properties props = new Properties();
        props.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "192.168.0.161:9092");
        props.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

//        List<String> interceptors = new ArrayList<>();
//        interceptors.add(CounterInterceptor.class.getName());
//        props.put(ProducerConfig.INTERCEPTOR_CLASSES_CONFIG, interceptors);

        KafkaProducer producer = new KafkaProducer<String, String>(props);
        for (int i=20;i<30;i++) {
            Future send = producer.send(new ProducerRecord<String, String>("test-ken-io", String.valueOf(i), "message-" + i));
            System.out.println("send:" + send.get());
        }
    }
}
```
``` java
public class BasicConsumer {
    public static void main(String[] args) {
        Properties properties = new Properties();
        properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "192.168.0.161:9092");
        properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());

        properties.put(ConsumerConfig.GROUP_ID_CONFIG, "test-group");
        KafkaConsumer consumer = new KafkaConsumer<String, String>(properties);
        consumer.subscribe(Arrays.asList("test-ken-io"));
        for(;;) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofSeconds(5));
            for(ConsumerRecord<String, String> record:records) {
                System.out.println(record);
            }
        }
    }
}
```

## 四、架构设计
p78～88,这tm精华好吧

## 五、深入部分
### 1.主题
- 主题创建（createToics指令处理）：
    - 1.对用户进行认证，并检查请求内容是否正确
    - 2.为新主题的分区生成AR副本列表
    - 3.zookeeper中创建节点，并存储主题相关元数据
    - 4.controller节点发消息给所有broker节点，更新集群元数据：如果被分配了leader副本，则需要接收生产者发送的消息;如果被分配了follow副本，则同步leader副本数据。

### 2.生产者与消息发布
### 3.消费者与消息订阅
### 4.消息存储机制与读写流程
### 5.消息主从同步
### 6.分布式协同

## 六、管理
### 1.安全
### 2.异地
### 3.监控




