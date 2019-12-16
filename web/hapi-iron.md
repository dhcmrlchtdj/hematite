# hapi iron

---

https://github.com/hapijs/iron/blob/master/API.md

之前没太懂，不知道什么时候文档补全了一点，就记录一下。

还是 Encrypt-then-MAC 的思路，默认是 aes-256-cbc 然后 sha256。

---

https://blog.cloudflare.com/it-takes-two-to-chacha-poly/

- AEAD 是怎么工作的
    - plaintext, key, iv, additional data
    - 使用 encryptionKey 和 iv 对 plaintext 进行加密（encrypt），得到 ciphertext
    - 使用 encryptionKey 生成 integrityKey，用于 hash function
        - generate a keyed hash of the AD, the ciphertext and the individual lengths of each
    - 生成 MAC，take the hash value and encrypt it （用的 encryptionKey？
    - 返回 ciphertext + MAC
- 为什么要 AEAD
    - 按我理解，只是在强制保证用户正确地 Encrypt-then-MAC
    - 很多人自己进行的话，会出现种种问题（错误的顺序、误用 key，等等等等

---

https://github.com/diafygi/webcrypto-examples#aes-gcm---encrypt

最后附上一个 web crypto 处理 AES_GCM 的例子

```typescript
const AES_GCM = async () => {
    const encode = (s: string) => new TextEncoder().encode(s)
    const decode = (u: Uint8Array) => new TextDecoder().decode(u)

    const subtle = window.crypto.subtle
    const random = (size: number) =>
        window.crypto.getRandomValues(new Uint8Array(size))

    const key = await subtle.generateKey(
        { name: 'AES-GCM', length: 256 },
        false,
        ['encrypt', 'decrypt'],
    )
    const once = () => {
        const iv = random(12)
        const additionalData = random(64)
        const encrypt = async (plaintext: string) => {
            const ciphertext = await subtle.encrypt(
                { name: 'AES-GCM', iv, additionalData, tagLength: 128 },
                key,
                encode(plaintext),
            )
            return new Uint8Array(ciphertext)
        }
        const decrypt = async (ciphertext: Uint8Array) => {
            const plaintext = await subtle.decrypt(
                { name: 'AES-GCM', iv, additionalData, tagLength: 128 },
                key,
                ciphertext,
            )
            return decode(new Uint8Array(plaintext))
        }
        return { iv, encrypt, decrypt }
    }
    return { once }
}
```
