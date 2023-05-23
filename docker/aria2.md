``` shell
docker run -d \
    --name aria2-pro \
    --restart unless-stopped \
    --log-opt max-size=100m \
    -e UMASK_SET=022 \
    -e PUID=$UID \
    -e PGID=$GID \
    -e RPC_SECRET=shafish \
    -e RPC_PORT=6800 \
    -p 6800:6800 \
    -e LISTEN_PORT=6888 \
    -p 6888:6888 \
    -p 6888:6888/udp \
    -e SPECIAL_MODE=move \
    -v /home/shafish/Data/docker/aria2/config:/config \
    -v /home/shafish/Data/docker/aria2/download:/downloads/completed \
    p3terx/aria2-pro:latest
```
``` shell
docker run -d \
    --name ariang \
    --log-opt max-size=100m \
    --restart unless-stopped \
    -p 6880:6880 \
    p3terx/ariang
```
``` yml
version: '3.3'
services:
    aria2-pro:
        container_name: aria2-pro
        restart: unless-stopped
        logging:
            options:
                max-size: 100m
        environment:
            - UMASK_SET=022
            - PUID=1000
            - PGID=1000
            - RPC_SECRET=shafish
            - RPC_PORT=6800
            - LISTEN_PORT=6888
            - SPECIAL_MODE=move
        ports:
            - '6800:6800'
            - '6888:6888'
            - '6888:6888/udp'
        volumes:
            - '/home/shafish/Data/docker/aria2/config:/config'
            - '/home/shafish/Data/docker/aria2/download:/downloads/completed'
        image: 'p3terx/aria2-pro:latest'
```
``` yml
version: '3.3'
services:
    ariang:
        container_name: ariang
        logging:
            options:
                max-size: 100m
        restart: unless-stopped
        ports:
            - '6880:6880'
        image: p3terx/ariang
```