## 一、ssh免密登录
- 1.本地生成rsa公私钥
```shell
ssh-keygen -t rsa -C 'shafish' -f 'shafish@graham.com'  # 一直回车
# 会在当前用户的.ssh目录下生成 id_rsa id_rsa.pub
```
- 2.服务器打开ssh密钥登录
```shell
vim /etc/ssh/sshd_config # 修改/开启下面两个配置
    PubkeyAuthentication yes  # 公钥认证
    AuthorizedKeysFile .ssh/authorized_keys  # 公钥认证文件路径
systemctl restart sshd # 重启一下ssh配置
mkdir ~/.ssh  # 新建密钥文件，如果已经存在则不需要以下4行操作
chmod 700 -R .ssh
touch authorized_keys
chmod 600 authorized_keys
# mkdir ~/.ssh && chmod 700 -R .ssh && cd .ssh && touch authorized_keys && chmod 600 authorized_keys
```
- 3.将本地公钥配置到服务器`.ssh/authorized_keys`中
    - 复制本地的公钥内容(~/.ssh/id_rsa.pub)
    - 粘贴到服务器对应文件(~/.ssh/authorized_keys)

- 4.添加本地ssh服务器
```shell
# 本地系统
vim ~/.ssh/config
# 添加以下内容
# Host 自定义连接服务器名称
Host myServer
# HostName 连接服务器IP
HostName 10.211.55.10
# Port 服务器 ssh 对外开放的端口
Port 22
# 登录服务器的用户
User root
# 本地服务器私钥文件地址
IdentityFile ~/.ssh/id_rsa
```
- 5.登录
`ssh myServer`

## 二、bbr
wget --no-check-certificate -O tcp.sh https://github.com/cx9208/Linux-NetSpeed/raw/master/tcp.sh && chmod +x tcp.sh && ./tcp.sh

## 三、ssl域名
在cloudflare登录成功的状态下打开，选择apiToken
https://dash.cloudflare.com/profile

```shell
export CF_Key="Global API Key"
export CF_Email="youEmail"
curl https://get.acme.sh | sh
acme.sh --issue --dns dns_cf -d 填上你需要tls的域名
# key为：域名.key
# 证书为：fullchain.cer
```

ref:https://moe.best/tutorial/acme-le-wc.html

## 四、防火墙
- 查询某个端口是否开启：`firewall-cmd --query-port=80/tcp --zone=public`
- 开启某个端口：`firewall-cmd --zone=public --add-port=80/tcp --permanent`
- `systemctl status firewalld`

## 五、添加环境变量
``` sh
vim /etc/profile.d/xxx.sh
```
``` sh
export JAVA_HOME=/opt/jdk-11.0.17
export PATH=$PATH:$JAVA_HOME/bin
```
``` sh
source /etc/profile.d/xxx.sh
```

## 六、软链接
``` shell
ln -s xxx xx/bin
```

## 七、磁盘修复
``` shell
sudo fsck -y /dev/sdb
# 如果卸载后依然提示磁盘被占有，检查被哪些进程占用
lsof | grep /dev/sdb
```

## 八、appimage
提示AppImages require FUSE to run.
``` shell
sudo add-apt-repository universe
sudo apt install libfuse2
```

## 九、Flatpak
```
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```
flatpak install flathub com.obsproject.Studio