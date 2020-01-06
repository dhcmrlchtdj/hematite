# nginx redirect

---

http://nginx.org/en/docs/http/ngx_http_rewrite_module.html
https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#307

---

最近一个项目里使用了 301 跳转，然后发现 `POST` 变成了 `GET`。
搜了一下，可以使用 307 来进行转发。

---

307 对应的是 302。
301 也有个对应的 308，但还不是正式标准。
