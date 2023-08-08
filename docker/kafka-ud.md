- 更新kafka docker镜像后出现容器闪退问题
参考解决：`https://github.com/bitnami/containers/issues/31789#issuecomment-1529977466`
https://github.com/bitnami/containers/blob/main/bitnami/kafka/README.md

``` yml
# zk
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
            - '/home/shafish/Data/docker/code/zk1/conf:/conf'
            - '/home/shafish/Data/docker/code/zk1/data:/data'
            - '/home/shafish/Data/docker/code/zk1/datalog:/datalog'
            - '/home/shafish/Data/docker/code/zk1/logs:/logs'
        image: zookeeper:3.6

```

``` yml
# kafka-broker
version: "3"
services:
    kafka:
        container_name: kafka-master # kafka-slave1 kafka-slave2
        image: 'bitnami/kafka:3.5.0'
        restart: unless-stopped
        user: root
        ports:
            - '9092:9092'
        volumes:
            - '/home/shafish/Data/docker/code/kafka-master:/bitnami/kafka'
            #- /path/to/server.properties:/bitnami/kafka/config/server.properties
        environment:
            - KAFKA_ENABLE_KRAFT=false
            - KAFKA_BROKER_ID=1
            - KAFKA_CFG_LISTENERS=PLAINTEXT://0.0.0.0:9092
            - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://192.168.0.103:9092
            - KAFKA_CFG_ZOOKEEPER_CONNECT=192.168.0.103:2181
            - ALLOW_PLAINTEXT_LISTENER=yes
```

``` yml
# kafka-ui
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
      - KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=192.168.0.103:9092
```