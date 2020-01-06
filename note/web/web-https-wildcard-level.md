# wildcard level

---

http://security.stackexchange.com/questions/10538/what-certificates-are-needed-for-multi-level-subdomains
https://tools.ietf.org/html/rfc6125#section-6.4.3
https://tools.ietf.org/html/rfc6125#section-7.2

---

没申请过 wildcard，一直不知道还有这个问题。

---

RFC 里 7.2 指出

+ 不建议使用 wildcard certificates
+ 现有的应用对 wildcard 的处理方式不一致
+ 也没有规范规定要怎么处理

---

RFC 里 6.4.3 说

+ 只允许 `*` 单独出现。`foo*.example.com` 这种是不允许的。
+ 只允许 `*` 出现在最左边。`foo.*.example.com` 这种是不允许的。
+ 只比较最左边的一级域名。`*.example.com` 只匹配 `foo.example.com`，不匹配 `bar.foo.example.com`。
