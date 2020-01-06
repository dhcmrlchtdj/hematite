# concatenate to one line

---

+ shell
+ grep
+ tr

---

+ http://stackoverflow.com/questions/15580144/concatenate-many-lines-of-output-to-one-line

---

```
$ brew install ffmpeg $(brew info ffmpeg | grep '^--with-' | tr '\n' ' ')
```
