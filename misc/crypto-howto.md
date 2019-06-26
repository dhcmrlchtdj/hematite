# 正确地加密数据

https://gist.github.com/tqbf/be58d2d39690c3b366ad
https://blog.helong.info/blog/2015/06/05/modern-crypto/

---

+ encrypting data
    1. NaCl/libsodium
    2. Chacha20-Poly1305
    3. AES-GCM

+ symmetric key length
    - 使用 256bit 的对称密匙

+ symmetric signatures
    - 使用 HMAC

+ hashing/HMAC algorithm
    - 使用 SHA-2 系列
    - 建议 SHA-512/256（将 SHA-512 的输出截断成 256）

+ random IDs
    - 使用 256bit 的随机数
    - /dev/urandom

+ password handling
    1. scrypt
    2. bcrypt
    3. PBKDF2

+ asymmetric encryption
    - 使用 NaCl
    - 不要使用 RSA。不得不用 RSA 时，至少用 RSA-OAEP

+ asymmetric signatures
    - NaCl
    - Ed25519
    - RFC6979

+ Diffie-Hellman
    1. NaCl
    2. Curve25519
    3. DH-2048 with a standard 2048 bit group

+ website security
    - OpenSSL
    - BoringSSL

+ client-server application security
    - TLS
