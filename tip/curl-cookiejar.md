# curl cookiejar

---

http://curl.haxx.se/docs/http-cookies.html

---

```
$ COOKIE=$(mktemp)
$ curl -b $COOKIE -c $COOKIE 'google.com'
$ rm $COOKIE
```
