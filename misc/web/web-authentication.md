# web authentication

---

https://blog.risingstack.com/web-authentication-methods-explained/

---

### HTTP Basic authentication

https://en.wikipedia.org/wiki/Basic_access_authentication

---

在 header 中设置 `Authorization`
将 `username:password` 进行 `base64` 编码

```
Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

---

每个请求都带着帐号和密码，很容易泄漏……

---

### Cookie

---

设置为 `HTTP only` 可以避免被 js 获取
还是要注意 CSRF 的处理

---

### Tokens

---

### JWT

---

JWT 分为 `header` `payload` `signature` 三部分
最后拼成 `xxxxx.yyyyy.zzzzz` 的格式

`header` 里面指定加密的方式
`payload` 是需要传递的数据，比如用户信息
`signature` 是对 `header` 和 `payload` 进行签名，防止前两者被伪造

---

一个问题是如何存储 JWT
如果用 cookie，我怎么感觉就是使用了一种标准通信方式而已。
而使用 storage + authentication，大部分人都认为 storage 不安全。

---

### Signatures

---

在请求时，对关键部分进行签名，防止伪造。

---

浏览器里，不太好弄？

---

### One-Time Passwords

---

可以基于时间或者基于计数，两步认证时很常用。

---

## summary

API 之间的通信使用签名
网页使用 cookie 或 token
客户端使用 token
