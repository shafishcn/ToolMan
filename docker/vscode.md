``` yml
version: "2.1"
services:
  code-server:
    image: lscr.io/linuxserver/code-server:latest
    container_name: code-server
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asian/ShangHai
      - PASSWORD=123456 #optional
      - SUDO_PASSWORD=123456 #optional
      - DEFAULT_WORKSPACE=/workspace #optional
    volumes:
      - /home/shafish/Data/docker/vscode/config:/config
      - /home/shafish/Data/docker/vscode/workspace:/workspace
      - /home/shafish/Data/docker/vscode/home:/root
    ports:
      - 8443:8443
    restart: unless-stopped
```