redis官方配置文件：https://github.com/redis/redis/blob/7.2/redis.conf

``` yml
docker run -v /home/shafish/Data/docker/redis:/usr/local/etc/redis --name myredis redis7.2 redis-server /usr/local/etc/redis/redis.conf
```

``` yml
version: '3.8'
services:
    redis:
        container_name: myredis
        restart: unless-stopped
        ports:
            - '6379:6379'
        volumes:
            - '/home/shafish/Data/docker/redis:/usr/local/etc/redis'
        command: redis-server /usr/local/etc/redis/redis.conf
        image: redis:7.2
```