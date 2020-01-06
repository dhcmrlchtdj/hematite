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

---

http://stackoverflow.com/questions/3377300/what-are-all-codecs-supported-by-ffmpeg

---

```
$ ffprobe input.webm
...
Stream #0:1: Audio: vorbis, 44100 Hz, stereo, fltp
...

$ ffmpeg -i input.webm -vn -acodec copy output.ogg
$ ffmpeg -i output.ogg -acodec aac output.aac

$ ffmpeg -i input.webm -vn -acodec aac output.aac
```

codec 后面具体的编码，可以看 `ffmpeg -codecs`
