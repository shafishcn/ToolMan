> 软件安装规范（安装目录约定）
https://www.cnblogs.com/ggjucheng/archive/2012/08/20/2647788.html

- /etc - 配置文件
- /opt - 第三方软件


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

- 下载oracle jdk压缩包
- `sudo tar xzvf jdk-xxxx -C /opt`
- `echo -e 'export JAVA_HOME="/opt/jdk-xxxx"\nexport PATH="$PATH:${JAVA_HOME}/bin"\n' | sudo tee /etc/profile.d/jdk11.sh`
- reboot

## 十一、VSCode java配置
> https://code.visualstudio.com/docs/java/java-tutorial

ctrl+p 安装java配置 `ext install vscjava.vscode-java-pack`


## 十二、i3wm来了（待续）
> i3配置文件路径：

## 十三、数据库
安装mariadb
```
pacman -S mariadb libmariadbclient mariadb-clients
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo mysql_secure_installation
```
设置密码`just1508`

给某个用户访问某数据库权限：
create user 'java'@'localhost' identified by 'just1508'
grant all privileges on lemonjamsdk.* to 'java'@'localhost'

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