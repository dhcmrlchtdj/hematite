# https cipher

---

https://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/elb-security-policy-table.html
https://github.com/letsencrypt/letsencrypt/wiki/Ciphersuite-guidance
https://wiki.mozilla.org/Security/Server_Side_TLS
https://googleonlinesecurity.blogspot.com/2013/11/a-roster-of-tls-cipher-suites-weaknesses.html

---

可以同时看一下之前一篇关于 ssh 配置的笔记，都是差不多的东西。

---

执行 `openssl ciphers` 可以看到当前支持的 `cipher suite`。
执行 `openssl ciphers -V` 可以看到所谓的 `suite` 由哪些部分组成。

---

比如 `ECDHE-RSA-AES128-GCM-SHA256` 可以拆解成

| key | value       | explanation                          |
| --- | ----------- | ------------------------------------ |
| Kx  | ECDH        | the key agreement mechanism          |
| Au  | RSA         | the authentication mechanism         |
| Enc | AESGCM(128) | the cipher                           |
| Mac | AEAD        | the message authentication primitive |

`ECDH` 而不是 `ECDHE`，后面的 E 表示 ephemeral，会比普通的更安全些。
`AEAD` 而不是 `SHA256`，因为 AESGCM 不需要 mac。

---

这个 cipher 怎么选，网上都是扔一个列表出来，然后也没一个对比。

各种缩写可以看 `man 1 ciphers`，可以用 `openssl ciphers -V` 检查缩写选定了哪些组合。

---

```
ECDHE-RSA-CHACHA20-POLY1305
ECDHE-RSA-AES128-GCM-SHA256
ECDHE-RSA-AES256-GCM-SHA384
ECDHE-RSA-AES128-SHA256
ECDHE-RSA-AES128-SHA
```

具体可以参考 aws 的文档，然后在 ssllab 上跑一下。
