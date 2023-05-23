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
```
  -p 8920:8920 \
  -p 7359:7359/udp \
  -p 1900:1900/udp \