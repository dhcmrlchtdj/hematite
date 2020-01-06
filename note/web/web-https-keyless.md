# keyless https

---

https://blog.cloudflare.com/keyless-ssl-the-nitty-gritty-technical-details/

---

回顾下创建 key 的过程

- 生成 domain private key
- 用 key 生成 csr
- 用 csr 生成 certificate

---

然后是和客户端建立连接的过程

- server 将 certificate 发送给 client
    - 包含了 public key 和 domain 等信息
    - 通过 client 本地的信任的证书，可以验证该 certificate 的可靠性
- RSA handshake
    - gen session key
        - `client -ClientRandom-> server`
        - `client <-ServerRandom+PublickKeyCert- server`
        - `client -PremasterSecet(encrypt with PublickKey)-> server`
    - client 持有 ClientRandom,ServerRandom,PremasterSecet
    - server 持有 ServerRandom,ClientRandom,PremasterSecet
    - 用三个数据生成 session key
    - PremasterSecet 通过证书里的 PublickKey 加密，server 自己进行解密
- DH handshake
    - gen session key
        - `client -ClientRandom-> server`
        - `client <-ServerRandom+PublickKeyCert- server`
        - `client <-ServerDHParameter+signature- server`
        - `client -ClientDHParameter-> server`
    - client/server 还是要交换 ClientRandom/ServerRandom
    - 继续交换 ClientDHParameter/ServerDHParameter，生成 PremasterSecet
    - 最终生成 session key
    - ServerDHParameter 经过 PrivateKey 签名，client 可以验证 ServerDHParameter 的可靠性

---

可以看到 RSA 和 DH 的差别
前者是 client 用 PublickKey 进行加密，server 用 PrivateKey 进行解密。
后者是 server 用 PrivateKey 进行签名，client 用 PublickKey 进行验证。

---

keyless 实现的原理，是把需要加解密的数据发回上游进行。
cloudflare 自己只要最后的 session key 就可以了。
在 RSA 中，上游需要进行解密；在 DH 中，上游需要进行签名。
