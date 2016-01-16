# crypto & ssh & https

---

## cryptography

---

首先澄清一点，我完全不懂 cryptography，完全不懂。

---

cryptography 主要干三件事情

+ encryption 加密
    不要看别人的东西
+ authentication 认证／signing 签名
    不要改别人的东西
+ identification 识别
    不要假装成别人

---

authentication 和 identification 有些容易混淆。
identification 只是标示，比如用户 A 是用户 A，
而 authentication 是行为认证，比如行为 B 是用户 A 发出的。

---

## ssh

---

### key exchange

```
$ ssh -vvv git@github.com
...
debug3: kex names ok: [curve25519-sha256@libssh.org]
...
debug2: kex_parse_kexinit: curve25519-sha256@libssh.org
...
debug2: kex_parse_kexinit: curve25519-sha256@libssh.org,ecdh-sha2-nistp256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
...
debug1: kex: server->client chacha20-poly1305@openssh.com <implicit> zlib@openssh.com
debug1: kex: client->server chacha20-poly1305@openssh.com <implicit> zlib@openssh.com
...
```

服务端和客户端都通过 `KexAlgorithms` 指定算法。
具体支持哪些算法可以通过 `ssh -Q kex` 查看。
交换的过程属于 `symmetric authentication`，
主要目的是决定后续的 `symmetric encryption` 使用哪种算法。

在上面的例子里，客户端只支持 `curve25519-sha256`，服务端还额外支持其他几种算法。
作为协商的结果，服务端和客户端在后续传递数据时，都使用 chacha20-poly1305 进行加密。

这里的交换算法，分为两大类，DH 和 ECDH。
条件允许就 Curve25519（属于 ECDH），条件不允许也至少 DH-2048（这个在服务端操作）。

怎么保证开始交换的密钥没被中间人替换，还没研究明白（非科班出生的基础劣势啊……）

---

### server authentication

```
$ ssh -vvv git@github.com
...
debug2: kex_parse_kexinit: ssh-ed25519,ssh-rsa
...
debug2: kex_parse_kexinit: ssh-dss,ssh-rsa
...
debug1: Server host key: ssh-rsa SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8
...
The authenticity of host 'github.com (192.30.252.128)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com' (RSA) to the list of known hosts.
...
```

第一次连接某个服务时，SSH 给出这台机器的 `fingerprint`。
之后，这个指纹会被存储下来，如果某次连接时，指纹出现变化，会给出提示。
通过认证，能够确定你连接的就是你想连接的那台服务器，除非你第一次存指纹的时候就已经被黑了。

服务端通过 `HostKey` 指定 key，
客户端通过 `HostKeyAlgorithms` 指定支持哪些类型的验证算法，
具体支持哪些算法，可以通过 `ssh -Q key` 查看。

在上面的例子里，
客户端支持 `ssh-ed25519,ssh-rsa` 两种方式，
服务端支持 `ssh-dss,ssh-rsa` 两种方式，
最后使用了 `ssh-rsa`。

这步验证属于 `asymmetric authentication`。
推荐使用 ED25519，不过像 github 就只支持 RSA，有啥用啥吧。

---

### client authentication

SSH 支持很多其他方式来认证用户，这里只讨论 `PubkeyAuthentication` 的方式。

```
$ ssh -vvv git@github.com
...
debug1: identity file $HOME/.ssh/id_ed25519 type 4
...
debug1: Offering ED25519 public key: $HOME/.ssh/id_ed25519
...
debug1: Authentication succeeded (publickey).
...
```

这里的过程和前面验证服务器很相似。

客户端将公钥上传到服务器，然后通过 `IdentityFile` 指定私钥，
服务端的 `AuthorizedKeysFile` 指向上传的公钥。

还是非对称认证，建议也和前面一样，条件允许就用 ED25519，不允许就 RSA。
都不允许的，这谁提供的服务没问题吗……

（其实网上还提到，RSA 用于验证时，应该使用 RSASSA-PSS，搞不懂啊……）

---

### encryption

```
$ ssh -vvv git@github.com
...
debug2: kex_parse_kexinit: chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
debug2: kex_parse_kexinit: hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256
...
debug2: kex_parse_kexinit: chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr,aes256-cbc,aes192-cbc,aes128-cbc,blowfish-cbc
debug2: kex_parse_kexinit: hmac-sha1,hmac-sha2-256,hmac-sha2-512
...
debug1: kex: server->client chacha20-poly1305@openssh.com <implicit> zlib@openssh.com
debug1: kex: client->server chacha20-poly1305@openssh.com <implicit> zlib@openssh.com
...
```

这里列出的是可选的 `Cipher` 和 `MAC` 以及最后使用的 `Cipher` 和 `MAC`。

客户端和服务器都通过 `Ciphers` 和 `MACs` 来指定支持的算法，
通过 `ssh -Q cipher/mac` 来查看可选算法。

通信过程中使用 Cipher 进行 `symmetric encryption`，然后用 MAC 进行 `symmetric authentication`。
根据前人的经验，正确的顺序是 Encrypt-then-MAC，先加密再认证。
后来更是出现了 `chacha20-poly1305` 这类整合了加密和认证的算法（还是先加密后认证，只是不需要手动指定了）。

条件许可，优先使用 `chacha20-poly1305` `aes-gcm` 这些不需要指定 MAC 的 Cipher。
条件不许可，Cipher 上 `aes-ctr`，MAC 有可能就 sha2-512，安全性越高越好。

---

### summary

总结一下 ssh 的通信过程。
先用对称认证交换密钥，然后通过非对称认证互相认证，最后使用对称加密来加密数据。
涉及到了 KEX，key，cipher，MAC 这些概念。
