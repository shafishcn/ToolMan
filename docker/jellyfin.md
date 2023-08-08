``` shell
docker run -d \
  --name=jellyfin \
  -e PUID=1000 \
  -e PGID=1000 \
  -p 8096:8096 \
  -v /home/shafish/Data/docker/jellyfin/config6:/config \
  -v /mnt/hgst/video/anime:/data/anime \
  --restart unless-stopped \
  nyanmisaka/jellyfin:latest

``` yml
version: '3.3'
services:
    jellyfin:
        container_name: jellyfinh
        environment:
            - PUID=1000
            - PGID=1000
            - NVIDIA_VISIBLE_DEVICES=all
        ports:
            - '8097:8096'
        volumes:
            - '/xxxx/config7:/config'
            - '/xxxx:/data/ghs3'
            - '/xxxx:/data/ghs1'
        restart: unless-stopped
        runtime: nvidia
        image: 'nyanmisaka/jellyfin:latest'
        deploy:
            resources:
                reservations:
                    devices:
                        - capabilities: [gpu]
```
  -p 8920:8920 \
  -p 7359:7359/udp \
  -p 1900:1900/udp \