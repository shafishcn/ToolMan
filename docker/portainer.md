``` shell
docker volume create portainer_data
# -p 8000:8000 -p 9443:9443
docker run -d -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```
``` yml
version: '3.3'
services:
    portainer-ce:
        ports:
            - '9000:9000'
        container_name: portainer
        restart: always
        volumes:
            - '/var/run/docker.sock:/var/run/docker.sock'
            - '/home/shafish/Data/docker/portainer/data:/data'
        image: 'portainer/portainer-ce:latest'
```