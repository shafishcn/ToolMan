实时硬盘SMART
## 单机检测
``` yml
docker run -d -p 8087:8080 -p 8086:8086 \
  -v /home/shafish/Data/docker/scrutiny/config:/opt/scrutiny/config \
  -v /home/shafish/Data/docker/scrutiny/influxdb2:/opt/scrutiny/influxdb \
  -v /run/udev:/run/udev:ro \
  --cap-add SYS_RAWIO \
  --device=/dev/sda \
  --device=/dev/sdb \
  --device=/dev/sdc \
  --name scrutiny \
  --restart unless-stopped \
  ghcr.io/analogj/scrutiny:master-omnibus
```

docker exec scrutiny /opt/scrutiny/bin/scrutiny-collector-metrics run

## 多机检测
``` yml
docker run --rm -p 8086:8086 \
  -v `pwd`/influxdb2:/var/lib/influxdb2 \
  --name scrutiny-influxdb \
  influxdb:2.2

docker run --rm -p 8080:8080 \
  -v `pwd`/scrutiny:/opt/scrutiny/config \
  --name scrutiny-web \
  ghcr.io/analogj/scrutiny:master-web
```
- 在需要检测硬盘的机器上执行
``` yml
docker run --rm \
  -v /run/udev:/run/udev:ro \
  --cap-add SYS_RAWIO \
  --device=/dev/sda \
  --device=/dev/sdb \
  -e COLLECTOR_API_ENDPOINT=http://SCRUTINY_WEB_IPADDRESS:8080 \ # scrutiny-web机器所在ip
  --name scrutiny-collector \
  ghcr.io/analogj/scrutiny:master-collector
```

docker exec scrutiny-collector /opt/scrutiny/bin/scrutiny-collector-metrics run