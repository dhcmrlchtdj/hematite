# OPAQUE

https://blog.cryptographyengineering.com/2018/10/19/lets-talk-about-pake/
https://blog.cloudflare.com/opaque-oblivious-passwords/

---

看了 cf 的文章才知道了 OPAQUE，算是 SRP 的后继者。（虽然没见过有人用 SRP…

---

为什么用 OPAQUE 而不是 SRP，最有力的一点

Unlike SRP, OPAQUE has a reasonable security proof (in a very strong model).

---

> The challenge here is that the salt is typically fed into a hash function
> (like scrypt) along with the password.
> If it's the server, then the server needs to see the password.
> If it's the client, then the client needs the salt.

第一个要解决的问题，要么传递 password，要么传递 salt，总是会有某些明文泄漏。

> the client has derived a key K, but the server has no idea what it is.
> Nor does the server know whether it's the right key.

第二个问题，服务端怎么判断客户端是否知道密码。

两个过程，都有点看不懂…

---

- client 持有 `name, password`
- server 持有 `server_public_key, server_private_key`
- server 存储 `User{name, OPRF_key, client_public_key, client_encrypted_envelope}`

注册的时候

- server 生成 OPRF_key, 发送 {OPRF_key, server_public_key} 给用户
- client 生成 randomKey=F(OPRF_key, password)
- client 生成 client_private_key, client_public_key
- client 生成 client_encrypted_envelope=F(client_private_key, randomKey+server_public_key)
- client 将 {client_public_key, client_encrypted_envelope} 发送给 server

登入的时候

- server 将 {OPRF_key, client_encrypted_envelope} 发送给 client
- client 生成 randomKey
- client 解开 client_encrypted_envelope，获得 client_private_key
- server 通过 client_public_key 认证 client

整个通信过程，都没有发送 password。
虽然不需要发送 salt，不过这里 OPRF_key 其实和 salt 也差不多了？
