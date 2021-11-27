## 安装
```shell
sudo pacman -S goldendict
```

## 使用
https://keatonlao.gitee.io/use-goldendict/

https://freemdict.com/2018/10/31/%e5%85%8d%e8%b4%b9%e5%bc%80%e6%ba%90%e8%af%8d%e5%85%b8%e8%bd%af%e4%bb%b6goldendict%e4%bd%bf%e7%94%a8%e4%bb%8b%e7%bb%8d/

## 词典
https://downloads.freemdict.com/100G_Super_Big_Collection/%E8%AF%8D%E9%A2%91/

https://downloads.freemdict.com/100G_Super_Big_Collection/%E8%AF%8D%E9%A2%91/%5B9.16%5D%E5%A4%9A%E5%8A%9F%E8%83%BD%E7%99%BE%E5%AE%9D%E7%AE%B1%E8%AF%8D%E5%85%B8%20-%20The%20little%20dict/

## 内置音频播放问题解决
- 安装好vlc
- 编辑-首选项-音频-使用外部程序播放
```shell
# 调用vlc 播放相关的api
cvlc  --play-and-stop -Vdummy
```