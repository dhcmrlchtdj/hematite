# ssh tunnel

---

https://gist.github.com/fnando/1101211
http://unix.stackexchange.com/questions/46235/how-does-reverse-ssh-tunneling-work
http://serverfault.com/questions/457295/removing-port-forwardings-programmatically-on-a-controlmaster-ssh-session

---

```
$ ssh -v -O forward -R remote_port:localhost:localhost_port hostname
$ ssh -v -O cancel -R remote_port:localhost:localhost_port hostname
```

`forward` 会把数据从 `remote_port` 转发到本地的 `local_port`。
再在上面加一层 nginx 就 ok 啦。

用完了，可以直接杀掉 ssh 进程，也可以用 `cancel` 来关掉转发。
