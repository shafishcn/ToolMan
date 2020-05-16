> 注意：本文是使用window提供的wls安装redis，并不是真正的物理机安装redis，之前使用docker安装过redis，单纯使用上来说不如在Linux上体验好。具体可以参考 这里:[redis的介绍与安装](https://shafish.cn/1222.html)

## redis版本
在window系统下，我们使用redis为项目做一些简单缓存，能直接安装在系统中的就只有微软在2016年停止维护的redis3.0.503。该版本也是redis的里程牌式release，官方支持了分布式的实现。

然而今天（2020年5月16日）去redis官网看到redis6.0.1稳定版都出来了，虽然redis官方并不建议在window系统中使用redis，但不是每个使用redis的开发者都是使用Linux或者Mac。

虽然可能不会使用到redis的全部功能~~，但是生命不就是在于折腾~~，下面讲讲如果在wls上安装redis。
[redis各版本介绍](https://www.cnblogs.com/xingxia/p/redis_versions.html)
[官方文档介绍](https://redis.io/documentation)

## wls准备
之前使用过debian的wls版，但有些Linux的命令没有，有些软件也可能安装姿势不对，加上安装了cmder，所以使用wls的频率并不高。在window build19041中更新了wsl2，感觉wls这个东西应该还能干上几年。本文不会安装`window build19041`开发版。
- 首先是更新了一下window系统
也是2018年买这台笔记本后第一次更新系统，如果你出现错误代码：0x80070424，可以参考：[Fix Error 0x80070424 in Windows Update and Microsoft Store](https://www.winhelponline.com/blog/error-0x80070424-windows-update-and-microsoft-store/)

- 第一步：搜索启用或关闭window功能，在`适用于linux的window子系统`前勾选上，ok
- 第二步：在`microsoft store`中搜索wls，选择一个合适的系统下载。也可以手动在[ Manually download Windows Subsystem for Linux distro packages ](https://docs.microsoft.com/en-us/windows/wsl/install-manual)安装。我这里选择Ubuntu18.04，下载安装即可。

- 第三步：输入账号密码，安装完毕后输入以下命令
```bash
sudo apt update
sudo apt install make
sudo apt install gcc
```

## redis最新版安装

- 第四步：安装redis
redis官方推荐适用gcc编译的方式安装redis，不推荐适用Linux软件管理器。继续：
```bash
cd ~ && mkdir Software && cd Software
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
```

- 第五步：配置redis启动路径
wls执行make install有问题，所以我们直接把make后在`src`目录中生成的执行文件放到`Linux path`中即可。
```
sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/
```

- 第六步：启动rendis服务
在redis-stable目录中有一个`redis.conf`文件，我们可以修改该文件作为`redis-server`启动的配置。
```bash
cd ~
mkdir config
cp Software/redis-stable/redis.conf ./config
cd ./cofig && vim redis.config
```
按照：[redis配置文件修改参考](https://gitee.com/shafish/frame_learn/blob/master/redis/%E6%9C%89%E5%9F%BA%E7%A1%80-redis%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E8%AF%B4%E6%98%8E-%E5%85%A5%E5%8F%A3.md) 看到合适就修改即可。

```
redis-server ~/config/redis.config
```

OK，redis服务端运行成功。

- 第七步：
    - 直接在程序中使用即可。
    - 如果需要在window系统中使用，还需要下载[redis-cli](https://github.com/ServiceStack/redis-windows/raw/master/downloads/redis-latest.zip)，安装完成后，不需要运行redis-server,只需要运行`redis-cli`即可。
    - 直接新建一个wls命令窗口，输入`redis-cli`使用。

OK。

ref:
- https://github.com/ServiceStack/redis-windows