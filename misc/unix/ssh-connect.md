# ssh connect

---

https://stribika.github.io/2015/01/04/secure-secure-shell.html
https://wiki.mozilla.org/Security/Guidelines/OpenSSH

---

ssh 中有 `key exchange algorithm` 和 `signature algorithm`。

---

signature 是验证连接的服务器。

初次建立连接时会提示 `Are you sure you want to continue connecting`。
连接之后，会在 `~/.ssh/known_hosts` 中记录下来。

`HostKeyAlgorithms` 可以用来选择加密方式。

```
HostKeyAlgorithms ssh-ed25519,ssh-rsa
```

服务端支持哪些则是使用 `HostKey`。

```
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
```

---

key exchange 是用来加密数据的。

`KexAlgorithms` `Ciphers` `MACs` 都是相关的参数。

```
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-512,hmac-sha2-256-etm@openssh.com,hmac-sha2-256
```

---

要建立 ssh 连接的时候，上面的参数都必须匹配才行
可以将输出开到 debug3 看对方支持哪些算法，实际使用了哪种算法

另外，如果使用的 Ciphers 支持 AE，就不会再使用 MACs 加密了。
