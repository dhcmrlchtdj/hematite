# everything you need to know about cryptography in 1 hour

https://blog.helong.info/blog/2015/04/12/translate-Everything-you-need-to-know-about-cryptgraphy-in-1-hour/

---

感觉文章太老，了解下基本概念就好
该用哪些东西，找其他资料吧

---

cryptography 主要干三件事情

+ encryption 加密
    不要看别人的东西
+ authentication 认证／signing 签名
    不要改别人的东西
+ identification 识别
    不要假装成别人

---

+ plaintext 是原文
+ ciphertext 是密文
+ key 用于转换原文和密文，即加密解密
+ symmetric cryptography 在加密解密时使用相同的 key
+ asymmetric cryptography 在加密解密时使用不同的 key

---

+ hash 将任意长度的输入转换为 n-bit 的输出
+ 抗碰撞，即需要 2^(n/2) 的时间才能找到输出相同的两个输入
+ 单向，即需要 2^n 的时间才能找出输入
+ 满足上述条件的才叫 hash function （？）

+ 使用 SHA-256
+ hash function 不是用来做 symmetric signature 的
+ DON’T: Put FreeBSD-8.0-RELEASE-amd64-disc1.iso and CHECKSUM.SHA256 onto the
    same FTP server and think that you’ve done something useful.（笑了

---

+ symmetric authentication 由 message authentication code 完成
+ MAC 有时被叫做 random function
+ MAC 使用一个 key 将任意长度的输入转换成 n-bit 的输出
+ 需要满足的条件是给出 (x, f(x)) 时，仍需要 2^n 的时间才能生成 (y, f(y))

+ 使用 HMAC-SHA256 来对称加密
+ 相同的输入给出的输出是相同的
+ 不要使用 Ploy1305 除非你的名字叫做 Daniel Bernstein（笑
    （不过文比较旧了，现在应该有可用的实现了？

---

+ 攻击者得到的 ciphertext 之外的信息，被称为 side channel
+ 比如时间，加密解密某个数据花费了多长时间什么的
+ （实现和使用的时候，尽可能避免 ciphertext 之外的信息外流就对了

---

+ symmetric encryption 通常基于 block ciphers 实现
+ block ciphers 有时被叫做 random permutation
+ block cipher 使用一个 key 将 n-bit 的输入 x 转换成 n-bit 的输出 E(x)，
    其中 x->E(x) 的映射是个双射，所以，后面我真得没看懂……

+ 使用 AES-256
+ 使用某种 mode

---

+ block cipher mode of operation 决定如何使用 block cipher 来保护数据
+ 大部分 mode 只提供 encryption，一部分同时提供 encryption 和 authentication

+ 使用 CTR mode
+ 使用 MAC 来 authentication
+ 正确的顺序是 Encrypt-then-HMAC
+ 在解密之前，先验证数据的签名，防治篡改
+ 不要使用同时提供 encryption 和 authentication 的 mode
    （是这样吗？GCM 不是应该更好吗……

---

+ asymmetric authentication
+ signing key 将 plaintext 转换为 ciphertext
+ verification key 将 ciphertext 转换为 plaintext，也可能 invalid signature
+ 没办法通过 verification key 计算出 signing key，
    但是通常可以通过 signing key 计算出 verification key
+ ciphertext 里通常会包含 plaintext 和 signature
+ 如果攻击者能生成有效的 ciphertext，那么这个 asymmetric authentication 就算玩完了

+ 使用 RSASSA-PSS (RSA signing with Probabilistic Signature Scheme padding)
+ 使用 2048-bit RSA key
+ 不要不加 padding，也不要使用 PKCS v1.5 padding
+ 不要使用 Elliptic Curve signature（？
+ 不要将一个 RSA key 同时用于 authentication 和 encryption

---

+ asymmetric encryption
+ public key 将 plaintext 转换为 ciphertext
+ private key 将 ciphertext 转换为 plaintext
+ 如果攻击者可以解密任意 ciphertext，那么这个 asymmetric encryption 就玩完了

+ 使用 RSAES-OAEP (RSA encryption with Optimal Asymmetric Encryption Padding)
+ 使用 2048-bit RSA key
+ 生成一个 key 用于信息的 symmetric encryption，然后对 key 进行 asymmetric encryption
    （要这么玩么……
+ 不要不加 padding，也不要使用 PKCS v1.5 padding

---

+ 尽可能，不要使用 password
+ 使用 key derivation function 将 password 转换成 key（？
+ 使用 PBKDF2 或者 scrypt，PBKDF2 更流行，scrypt 更安全
+ 不要存储密码（？

---

+ 关于 SSL，直接看其他文

---

最后总结一下，大概知道了

+ encryption / authentication
+ symmetric / asymmetric
