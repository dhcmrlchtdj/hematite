# gnutls priority

---

https://www.gnutls.org/manual/html_node/Priority-Strings.html
http://blog.lighttpd.net/gnutls-priority-strings.html

---

像 anyconnect / weechat 之类的工具，都是使用 gnutls。
只会设置 openssl 的 ciphers，不知道 gnutls 怎么选择。
所以，记录一下。

---

目标，和 openssl 那边差不多

+ ECDHE 或者 DHE
+ ECDSA 或者 RSA
+ CHACHA20-POLY1305 或者 AESGCM，AESCBC 看情况？
+ SHA256 以上

---

可以使用 `gnutls-cli -l --priority="NORMAL"` 来查看被选中的 `cipher suites`

真得，挺难用的

---

从 `SECURE256` 开始慢慢减，得到了

`SECURE256:-RSA:-ECDHE-RSA:-AES-256-CBC:-CAMELLIA-256-CBC:-CAMELLIA-256-GCM:-AES-256-CCM`

不过通用性不行
