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
- 列出所有字幕：`youtube-dl --list-subs [url]`
- 字幕类型`--sub-format "srt" or "ass/srt/best"`
- 字幕语言：`--sub-lang LANGS`
- 指定视频下载名称:`youtube-dl [options] [url] -o /home/shafish/Downloads/Video/%(title)s.%(ext)s` // '%(title)s.%(ext)s'

### 下载
- 视频下载：`youtube-dl --proxy socks5://127.0.0.1:1080/ -o '/home/shafish/Downloads/Video/%(title)s.%(ext)s' -f best [url]`
- 自动翻译的字幕下载：`youtube-dl --proxy socks5://127.0.0.1:1080/ -o '/home/shafish/Downloads/Video/%(title)s.%(ext)s' --write-auto-sub [url]`
- 指定字幕下载：
    - 列出所有字幕：`youtube-dl --proxy socks5://127.0.0.1:1080/ --list-subs [url]`
    - 选择下载格式与语言：`youtube-dl --proxy socks5://127.0.0.1:1080/ --all-subs --skip-download [url]`

- 合并音视频：`ffmpeg -i video.mp4 -i audio.wav -c:v copy -c:a aac -strict experimental output.mp4`

- 烧字幕：
    - `ffmpeg -i xxx.vtt xxx.srt` [option]
    - `ffmpeg -i input.mp4 -vf subtitles='xxx.srt' output.mp4`
- 分片
    - `ffmpeg -y -i input.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb 转换视频.ts`    
    - `ffmpeg -i 转换视频.ts -c copy -map 0 -f segment -segment_list 视频索引.m3u8 -segment_time 5 前缀-%03d.ts`

youtube-dl --proxy socks5://127.0.0.1:1080/ -o 'Network-Connectors-Explained.%(ext)s' -f 248 https://www.youtube.com/watch?v=ktTtAQIvYkg

https://www.youtube.com/watch?v=PVad0c2cljo
    
ffmpeg -i Network-Connectors-Explained.mp4 -i Network-Connectors-Explained.m4a -c:v copy -c:a aac -strict experimental networkConnectorsExplained.mp4

ffmpeg -y -i networkConnectorsExplained.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb networkConnectorsExplained.ts


ffmpeg -i networkConnectorsExplained.ts -c copy -map 0 -f segment -segment_list networkConnectorsExplained.m3u8 -segment_time 40 networkConnectorsExplained-%03d.ts