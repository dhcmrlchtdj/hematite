# ESNI

https://blog.cloudflare.com/encrypted-sni/
https://blog.cloudflare.com/esni/

---

HTTPS 虽然能加密内容，但还是会泄漏域名信息。

- 进行 DNS 解析的时候，会泄漏域名。
- 获取证书的时候，SNI 会泄漏域名。

针对这两种场景，现在都有了新的加密方法。

- DNS 有了 DNS over TLS 和 DNS over HTTPS，这样就不会泄漏 DNS 查询情况
- SNI 有了 ESNI，请求域名证书时的域名也经过加密

如何在没有交换过 KEY 的情况下实现 ESNI 的域名加密呢？答案是 DNS。
在 DNS 解析结果里，有服务器的 PublicKey，浏览器通过 KEY 对域名进行加密，实现全程加密。
