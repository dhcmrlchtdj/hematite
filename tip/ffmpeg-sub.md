# ffmpeg sub

---

https://gist.github.com/sxyx2008/9d5572a25063790db5fb
https://ffmpeg.org/pipermail/ffmpeg-user/2015-May/026765.html

---

```
$ ffmpeg -i <input.mp4> -i <input.ass> -c copy -c:s mov_text <output.mp4>
```

`-c copy -c:s mov_text` 算是 `-c:v copy -c:a copy -c:s mov_text` 的缩写

---

```
$ ffmpeg -i video.avi -vf subtitles=subtitle.srt out.avi
```
