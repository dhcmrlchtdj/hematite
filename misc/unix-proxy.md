# proxy

---

https://wiki.archlinux.org/index.php/proxy_settings

---

mac 上换用 ss 后，不像 vpn 走全局代理，有方便的时候也有麻烦的时候。

```
export no_proxy="localhost,127.0.0.1/8"
export all_proxy="socks5://127.0.0.1:1080"
export http_proxy=$all_proxy
export https_proxy=$all_proxy
export rsync_proxy=$all_proxy
export ftp_proxy=$all_proxy
```
