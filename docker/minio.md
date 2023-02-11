``` yml
version: '3.3'
services:
    data:
        container_name: minio
        restart: unless-stopped
        ports:
            - '9001:9000'
            - '9091:9090'
        volumes:
            - '/mnt/docker-hgst/data/minio/data:/data'
            - '/data/docker/minio/config:/root/.minio'
        environment:
            - MINIO_SITE_NAME=minio-shafish
            - MINIO_ROOT_USER=shafish
            - MINIO_ROOT_PASSWORD=shafish123
            - MINIO_SERVER_URL=http://192.168.0.151:9091 # api
            - MINIO_BROWSER_REDIRECT_URL=http://192.168.0.151:9091
        command: server /data  --console-address ":9000" --address ":9090"
        healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
            interval: 30s
            timeout: 20s
            retries: 3
        image: quay.io/minio/minio
```