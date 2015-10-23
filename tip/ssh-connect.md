# ssh connect

---

https://stribika.github.io/2015/01/04/secure-secure-shell.html
http://security.stackexchange.com/questions/50878/ecdsa-vs-ecdh-vs-ed25519-vs-curve25519

---

ssh 中有 `key exchange algorithm` 和 `signature algorithm`。

---

signature 是验证连接的服务器。

初次建立连接时会提示 `Are you sure you want to continue connecting`。
连接之后，会在 `~/.ssh/known_hosts` 中记录下来。

`HostKeyAlgorithms` 可以用来选择加密方式。

```
HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-ed25519,ssh-rsa-cert-v01@openssh.com,ssh-rsa
```

服务端支持哪些则是使用 `HostKey`。

```
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
```

---

key exchange 是用来加密数据的。

`KexAlgorithms` `Ciphers` `MACs` 都是相关的参数。

```
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-ctr,aes256-gcm@openssh.com,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-512,hmac-sha2-256-etm@openssh.com,hmac-sha2-256
```

---

SSH 连接建立的时候

1. key exchange, `KexAlgorithms`
2. authentication, `HostKeyAlgorithms`
3. symmetric ciphers, `Ciphers`
4. message authentication codes, `MACs`

如果 `Ciphers` 支持 `AE cipher mode`，会跳过第四步，如果不支持，会选择想要的 MAC。

每一步都需要 server 和 client 匹配。
