# youtube-dl使用教程
> https://github.com/ytdl-org/youtube-dl

## 安装
```
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```

## 使用命令
`youtube-dl [OPTIONS] URL [URL...]`

### options
- 设置socks5代理：`youtube-dl --proxy socks5://127.0.0.1:1080/ [url]`
- 查看油管视频所有资源：`youtube-dl --list-formats [url]`
- 下载指定质量的视频并自动合并（音视频）：`youtube-dl -f [format code] [url]` // best
- 下载自动翻译的字幕：`youtube-dl --write-auto-sub [url]`
- 指定视频下载名称:`youtube-dl [options] [url] -o /home/shafish/Downloads/Video/%(title)s.%(ext)s` // '%(title)s.%(ext)s'

### 下载
- 视频下载：`youtube-dl --proxy socks5://127.0.0.1:1080/ -o '/home/shafish/Downloads/Video/%(title)s.%(ext)s' -f best [url]`
- 字幕下载：`youtube-dl --proxy socks5://127.0.0.1:1080/ -o '/home/shafish/Downloads/Video/%(title)s.%(ext)s' --write-auto-sub [url]`
- 烧字幕：
    - `ffmpeg -i xxx.vtt xxx.srt`
    - `ffmpeg -i input.mp4 -vf subtitles='xxx.srt' output.mp4`
- 分片
    - `ffmpeg -y -i input.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb 转换视频.ts`    
    - `ffmpeg -i 转换视频.ts -c copy -map 0 -f segment -segment_list 视频索引.m3u8 -segment_time 5 前缀-%03d.ts`
    