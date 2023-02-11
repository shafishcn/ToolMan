``` shell
docker run --name mattermost-preview \
  --publish 8065:8065 \
  --add-host dockerhost:127.0.0.1 \
  --rm \
  -d mattermost/mattermost-preview
```
``` shell
# 复制配置文件
docker container cp mattermost-preview:/mm/mattermost/config /data/docker/mattermost/config/
```

``` yml
version: '3.3'
services:
    mattermost:
        container_name: mattermost-preview
        restart: unless-stopped
        ports:
            - '8065:8065'
        volumes:
            - '/data/docker/mattermost/config:/mm/mattermost/config'
            - '/data/docker/mattermost/mysql:/var/lib/mysql'
            - '/data/docker/mattermost/data:/mm/mattermost-data'
        image: mattermost/mattermost-preview
```