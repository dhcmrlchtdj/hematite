# xargs vs read

---

http://stackoverflow.com/questions/2574134/when-should-xargs-be-preferred-over-while-read-loops

---

之前写命令，忘了有 xargs 这东西，硬是用 `while read` 写了一个，然后发现用 `while read` 也挺好的。

```
$ echo 'a\nb' | while read; do echo $REPLY; done
```
