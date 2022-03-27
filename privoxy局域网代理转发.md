## 安装
sudo pacman -S privoxy

## 配置

sudo vim /etc/privoxy/config

listen-address 0.0.0.0:8118      #这一行可以选择任意未使用端口，0.0.0.0表示局域网可用
forward-socks5 / 127.0.0.1:1080 .  #不要漏掉这里的点

sudo systemctl enable privoxy.service
sudo systemctl restart privoxy.service