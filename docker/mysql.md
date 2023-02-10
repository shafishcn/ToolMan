> 开发用

``` yml
version: '3.3'
services:
    mysql:
        container_name: mysql8
        restart: unless-stopped
        ports:
            - '3306:3306'
            - '33060:33060'
        volumes:
            - '/data/docker/mysql/conf:/etc/mysql/conf.d'
            - '/data/docker/mysql/datadir:/var/lib/mysql'
        environment:
            - MYSQL_ROOT_PASSWORD=shafish123456
        image: mysql:8.0
```