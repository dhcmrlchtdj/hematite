# ffmpeg extract audio

---

之前记过一条命令

```
$ ffmpeg -i input.mkv -vn -acodec copy output.aac
```

刚才搜了下怎么查看文件的编码

```
$ ffmpeg -i input.mkv
$ ffprobe input.mkv
```

两个方式都能达到目的
