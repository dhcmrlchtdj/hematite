# Public Key Pinning

---

https://developer.mozilla.org/en-US/docs/Web/Security/Public_Key_Pinning

---

指定证书，防止 MITM 攻击。

```
Public-Key-Pins: pin-sha256="base64=="; max-age=expireTime [; includeSubdomains][; report-uri="reportURI"]
```

这里的 base64，可以直接在本地生成

```
$ openssl s_client -connect www.example.com:443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```

---

之前写得太过简单。
需要注意一点，`HPKP is a Trust on First Use (TOFU) technique`。
和 SSH 的服务器 fingerprint 类似，HPKP 其实是第一次成功建立连接时的证书指纹。
在有效期内，如果发现证书变化就认为证书被中间人替换了。
