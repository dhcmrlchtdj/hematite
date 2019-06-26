# curl querystring

---

http://unix.stackexchange.com/questions/86729/any-way-to-encode-the-url-in-curl-command

---

```
$ curl $url -G --data-urlencode 'x=hello' --data-urlencode 'y=world'
```

`--data-urlencode` 能对数据进行编码，让 `-G` 指定发 `GET` 请求
这样就可以对 querystring 进行编码啦
