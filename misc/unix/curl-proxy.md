# curl proxy

---

http://superuser.com/questions/303251/how-to-check-if-a-socks5-proxy-works
http://stackoverflow.com/questions/24568788/doing-https-requests-through-a-socks5-proxy-tor-with-curl

---

```
$ export all_proxy="socks5://127.0.0.1:1080"
$ curl -v 'https://example.com'
*   Trying 127.0.0.1...
* Connected to 127.0.0.1 (127.0.0.1) port 1080 (#0)
* Server aborted the SSL handshake
* Closing connection 0
curl: (35) Server aborted the SSL handshake
```

在 curl 请求 https 时，代理不能正常工作。
搜了一下，最后发现，好像是 DNS 被污染了的关系……

好在 curl 提供了 `socks5h` 的支持

```
$ export all_proxy="socks5h://127.0.0.1:2080"
$ curl -v 'https://example.com'
...
```
