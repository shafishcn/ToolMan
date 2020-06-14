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
