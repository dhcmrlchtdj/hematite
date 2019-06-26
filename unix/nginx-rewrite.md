# nginx rewrite

---

+ http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite

---

```
location /slide {
    rewrite ^ / break;
    root /home/user/slide;
}
```
