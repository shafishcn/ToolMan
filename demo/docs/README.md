# Headline

> An awesome project.

youtube-dl --proxy socks5://127.0.0.1:1080/ -f 137 https://www.youtube.com/watch?v=1I5ZMmrOfnA
youtube-dl --proxy socks5://127.0.0.1:1080/ --all-subs --skip-download https://www.youtube.com/watch?v=1I5ZMmrOfnA

ffmpeg -i 'How Computers Calculate - the ALU - Crash Course Computer Science #5-1I5ZMmrOfnA.mp4' -i 'How Computers Calculate - the ALU - Crash Course Computer Science #5-1I5ZMmrOfnA.m4a' -c:v copy -c:a aac -strict experimental 'How Computers Calculate - the ALU - Crash Course Computer Science #5.mp4'

ffmpeg -i 'How Computers Calculate - the ALU - Crash Course Computer Science #5.mp4' -vf subtitles='How Computers Calculate - the ALU - Crash Course Computer Science #5-1I5ZMmrOfnA.zh-CN.vtt' 'howComputersCalculate-TheALU-cn-#5.mp4'

ffmpeg -y -i 'howComputersCalculate-TheALU-en-#5.mp4' -vcodec copy -acodec copy -vbsf h264_mp4toannexb 'howComputersCalculate-TheALU-en-#5.ts'
ffmpeg -i 'howComputersCalculate-TheALU-en-#5.ts' -c copy -map 0 -f segment -segment_list howComputersCalculate-TheALU-en.m3u8 -segment_time 60 howComputersCalculate-TheALU-en-%03d.ts