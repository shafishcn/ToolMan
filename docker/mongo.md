``` yml
version: '3.3'
services:
    mongo:
        container_name: mongo
        ports:
            - '27017:27017'
        restart: unless-stopped
        volumes:
            - '/data/docker/mongo/db:/data/db'
            - '/data/docker/mongo/conf:/etc/mongo/mongo.conf'
        environment:
            - MONGODB_INITDB_ROOT_USERNAME=shafish
            - MONGODB_INITDB_ROOT_PASSWORD=shafish123456
        image: 'mongo:latest'
```