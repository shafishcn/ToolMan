> 软件安装规范（安装目录约定）
https://www.cnblogs.com/ggjucheng/archive/2012/08/20/2647788.html

- /etc --> 配置文件
- /opt --> 第三方软件
- /data --> docker数据挂载目录
- /run/media/graham --> 外置硬盘路径
- /home/graham/Documents --> 文档编写记录
- /home/graham/Project/{Git,Java} --> 项目工程目录


## 一、obs没有声音
`sudo pacman -Sy pulseaudio`
reboot

## 二、fcitx no wrok
进入输入法配置，点击+时需要取消选中 `Only show current language`
- 安装
    - `sudo pacman -S fcitx fcitx-im fcitx-configtool`
    - vim ~/.xprofile
    ```
    #fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
    ```
    - `sudo pacman -S fcitx-googlepinyin`
    - `vim ~/.i3/config`添加`exec_always fcitx`表示自启动

## 三、设置多屏
> https://fhxisdog.github.io/posts/manjaro-i3wm%E6%8E%A5%E5%85%A5%E5%A4%96%E6%8E%A5%E6%98%BE%E7%A4%BA%E5%99%A8%E4%B8%8D%E6%98%BE%E7%A4%BA/

- 1.输入xrandr查看屏幕设备接口：外设一般为`HDMIx`,自带屏幕为：`eDP1`
- 2.设置外设屏幕在右边
```sh
xrandr --output HDMI1 --right-of eDP1 --auto
```

## 四、同步时间
```
sudo hwclock --systohc
同步时间
ntpdate -u ntp.api.bz
```

## 五、系统分区
gparted

## 六、wps
sudo pacman -S wps-office
sudo pacman -S ttf-wps-fonts
如果无法输入中文->在/usr/bin/wps文件中第二行输入
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"

## 七、iease-music 改成网易云
sudo pacman -S iease-music

## 八、trojan开启自启动
systemctl enable trojan

## 九、修改终端字体 .Xresources
```
URxvt.font:                       xft:Source Code Pro:antialias=True:pixelsize=16,xft:WenQuanYi Zen Hei:pixelsize=16
URxvt.boldfont:                   xft:Source Code Pro:antialias=True:pixelsize=16,xft:WenQuanYi Zen Hei:pixelsize=16
```

## 十、为所有用户配置java开发配置
> https://linuxhint.com/install_jdk_12_arch_linux/

- 下载oracle jdk压缩包p232p
- `sudo tar xzvf jdk-xxxx -C /opt`
- `echo -e 'export JAVA_HOME="/opt/jdk-xxxx"\nexport PATH="$PATH:${JAVA_HOME}/bin"\n' | sudo tee /etc/profile.d/jdk11.sh`
- 命令行:source /etc/profile

> 或者使用包管理工具

```shell
sudo pacman -S jdk8-openjdk
sudo pacman -S jdk11-openjdk
# 使用archlinux-java切换java版本
archlinux-java status
archlinux-java set java-8-openjdk
```

## 十一、VSCode java配置
> https://code.visualstudio.com/docs/java/java-tutorial

ctrl+p 安装java配置 `ext install vscjava.vscode-java-pack`


## 十二、i3wm来了（待续）
> i3配置文件路径：

## 十三、数据库
- 1.安装mariadb
```sh
pacman -S mariadb libmariadbclient mariadb-clients
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl start mysql #启动mysql服务
# sudo mysql_secure_installation
```
- 2.设置密码`just1508`
```sh
sudo mysql -u root -p
FLUSH PRIVILEGES;
ALTER USER root@localhost IDENTIFIED VIA mysql_native_password USING PASSWORD("just1508");
exit
sudo systemctl restart mysql
```

- 3.给某个用户访问某数据库权限：
create user 'java'@'localhost' identified by 'just1508'
grant all privileges on lemonjamsdkpro.* to 'java'@'localhost'

- 4.修改用户权限(密码)
https://mariadb.org/authentication-in-mariadb-10-4/

跳过密码登录mysql后需要先执行更新权限命令`FLUSH PRIVILEGES;`再alter user 'root'@'localhost' identified by '密码';

- 5.添加字段
```sql
`verification` tinyint(2) unsigned DEFAULT '1' COMMENT '账号是否通过验证。1已经验证；2没有被验证。提供手机验证码默认已经验证，邮箱注册则默认没被验证',
`id_verification` tinyint(2) DEFAULT NULL COMMENT '是否通过了身份证验证。1通过；2没通过',
```

alter table user_auth add `verification` tinyint(2) unsigned DEFAULT '1' COMMENT '账号是否通过验证。1已经验证；2没有被验证。提供手机验证码默认已经验证，邮箱注册则默认没被验证';
alter table user_auth add `id_verification` tinyint(2) DEFAULT NULL COMMENT '是否通过了身份证验证。1通过；2没通过';

## 十四、vscode插件
> https://zhuanlan.zhihu.com/p/35176928

代码高亮：
ext install HookyQR.beautify
多项目管理：
ext install alefragnani.project-manager

> java 开发快捷键：https://code.visualstudio.com/docs/java/java-editing

保存时自动格式化代码
```
"editor.formatOnType": true,
"editor.formatOnSave": true
```

### java生产力
- 自动导入依赖：alt+shift+o
- 类重写方法：右键 source action
- 

## 十六、另一个包管理工具
```
sudo pacman -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

sudo snap install snap-store
```

## 十七、深度文件管理
```
sudo pacman -S deepin-file-manager
sudo pacman -S deepin-screenshot
```

## 十八、指定任意软件代理
proxychain:https://github.com/rofl0r/proxychains-ng
```
https://github.com/rofl0r/proxychains-ng
cd proxychains-ng
sudo ./configure --prefix=/usr --sysconfdir=/etc
sudo make
sudo make install 
sudo make install-config
sudo vim /etc/proxychains.conf #修改为`socks5  127.0.0.1 1080`，具体根据用户使用的代理软件设置
```
ok!
以后需要使用代理的命令或者软件只需要在命令行前加上`proxychains4`启动即可。比如
```
curl myip.ipip.net
# 使用代理
proxychains4 curl myip.ipip.net
```
再次ok
> 因为使用的是trojan，只支持sock5，平时使用的wget，curl等都是htp_proxy，无法用sock5代理，而proxychain可以把http_proxy代理到socks5上。

> 问题:docker pull镜像使用proxychain代理无效(待解决)

## 十九、程序启动时,指定工作区
sudo pacman -S xorg-xprop
 xprop运行,移动鼠标获取WM_CLASS(STRING) = XXXX
 写入.i3/config中
 ```
assign [class="(?i)Chrome"] $ws2
 ```

## aria2
https://zhuanlan.zhihu.com/p/77336764

## minio和jellyfin
```
docker run -p 9000:9000 --name minio -v /data/minio/data:/data -v /data/minio/config:/root/.minio -d --restart unless-stopped minio/minio server /data
```

```
docker run -d -v /data/jellyfin/config:/config -v /data/jellyfin/cache:/cache -v /run/media/graham/In-Reserve/video:/media --user 1000:1000 --net=host --restart=unless-stopped --privileged=true jellyfin/jellyfin
```

```
docker create --name=jellyfin -e PUID=1000 -e PGID=1000 -p 8096:8096 -v /data/jellyfin/config:/config -v /data/jellyfin/cache:/cache -v /run/media/graham/In-Reserve/video/b:/data/b  -v /run/media/graham/In-Reserve/video/t:/data/t -v /run/media/graham/In-Reserve/video/video:/data/video -v /run/media/graham/In-Reserve/video/new:/data/new -v /run/media/graham/In-Reserve/资料:/data/codding --restart unless-stopped linuxserver/jellyfin
```
## m3u8
```
ffmpeg -i 本地视频地址 -y -c:v libx264 -strict -2 转换视频.mp4
ffmpeg -y -i 本地视频.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb 转换视频.ts
ffmpeg -i 本地视频.ts -c copy -map 0 -f segment -segment_list 视频索引.m3u8 -segment_time 5 前缀-%03d.ts
```

https://segmentfault.com/q/1010000007235579

## 二十:睡眠后断网的情况
卸载网卡驱动:modprobe -r r8169
重装驱动:modprobe r8169

/home/graham/Project/Git/lemonsdkserver/src/db/lemonjamsdkpro702.sql

docker run -u root -d -p 49080:8080 -p 50000:50000 -v /data/jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean

## QQ:http://www.waimaosns.cc/arch-linux-i3wm-run-deepin-qq-tim/
或者安装qq官方-qqlinux
- 图标
yay -S la-capitaine-icon-theme

nohup /usr/lib/gsd-xsettings > /dev/null 2>&1 &

## 风格主题
https://minifullc.github.io/2018/03/20/Arch%20Linux%20%E7%B3%BB%E7%BB%9F%E9%A2%9C%E8%89%B2%E9%85%8D%E7%BD%AE/

sudo pacman -S  qt5-styleplugins qt5ct
sudo pacman -S dconf editor

打开lxappearance设置

## git客户端
- 私有仓库收费:gitkraken
- githubDesktop:https://github.com/shiftkey/desktop

## gnome
https://wiki.manjaro.org/index.php/Install_Desktop_Environments#Gnome_3

## 本地聊天室
https://github.com/yinxin630/fiora/blob/master/doc/README.ZH.md

```
拉取 mongo 镜像 docker pull mongo
拉取 fiora 镜像 docker pull suisuijiang/fiora
创建虚拟网络 docker network create fiora-network
启动数据库 docker run --name fioradb -p 27017:27017 --network fiora-network mongo
启动fiora docker run --name fiora -p 9200:9200 --network fiora-network -e Database=mongodb://fioradb:27017/fiora suisuijiang/fiora
```

## 蓝牙模块包
sudo pacman -S bluez bluez-utils

## ssh工具
```shell
# 收费版提供sftp功能,待观察购买
ssh免费: sudo snap install termius-app
# 国产shell+ftp
rm -f finalshell_install_linux.sh ;wget www.hostbuf.com/downloads/finalshell_install_linux.sh;chmod +x finalshell_install_linux.sh;./finalshell_install_linux.sh;
# 有点丑
filezilla
```

## 访问window共享文件
- window系统新建share用户，创建共享文件夹，赋予share用户
- linux设置
```sh
sudo pacman -S samba manjaro-settings-samba # 安装sam
smbclient -L //SHAFISH/ -U share -m SMB2 # 扫描//SHAFISH计算机上的所有共享文件夹
输入share用户的密码 # 输入share用户的密码
sudo mkdir /dev/share   # linux下创建共享文件夹挂载点
vim /etc/fstab # 添加共享文件夹的关于文件编码的配置
## //window主机ip地址/需要共享的文件夹名称 创建的linux挂载点 cifs defaults,user=window共享用户名,password=window共享密码,_netdev,vers=3.0 0 0
//192.168.0.108/share /dev/share cifs defaults,user=share,password=share,_netdev,vers=3.0 0 0
sudo mount -a ##读取配置文件重新挂载
df -Th ## 查看挂载情况
cd /dev/share ## window共享文件夹内容
```

## git命令中文乱码
```sh
git config --global core.quotepath false
```

## 安装nodejs
- 1.安装脚本
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
```
- 2.配置环境
```sh
# 在.zshrc或者.bashrc末尾添加
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```
- 打开终端输入nvm验证
- 3.查看nodejs版本：`nvm ls-remote`  
- 4.下载稳定版本这里是v12.19.0：`nvm install v12.19.0`
- 5.ok安装完成！！
参考：https://ostechnix.com/install-node-js-linux/
淘宝镜像：https://blog.csdn.net/qq_36410795/article/details/86485595  ->`npm config set registry=https://registry.npm.taobao.org`