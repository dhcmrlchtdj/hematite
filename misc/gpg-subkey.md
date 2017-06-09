# gpg subkey

---

https://sks-keyservers.net/overview-of-pools.php
https://www.void.gr/kargig/blog/2013/12/02/creating-a-new-gpg-key-with-subkeys/
https://help.riseup.net/en/gpg-best-practices

---

`gpg -k` 和 `gpg -K` 输出的意思

```
sec => 'SECret key'
ssb => 'Secret SuBkey'
pub => 'PUBlic key'
sub => 'public SUBkey'
```

```
PUBKEY_USAGE_SIG      S       key is good for signing
PUBKEY_USAGE_CERT     C       key is good for certifying other signatures
PUBKEY_USAGE_ENC      E       key is good for encryption
PUBKEY_USAGE_AUTH     A       key is good for authentication
```

---

`~/.gnupg/gpg.conf` 的配置

```
no-greeting
no-version
use-agent
armor
keyid-format 0xlong
with-fingerprint
verify-options show-uid-validity
list-options show-uid-validity
personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
cert-digest-algo SHA512
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB Uncompressed
```

---

`gpg --edit-key` 来修改、增加、删除

uid 1
adduid / deluid

key 1
addkey / delkey
expire

---

每次更新 subkey / uid 之类的后，都要重新导出 pubkey，不过 fingerprint 是不会变的。

---

`gpg --edit-key` 可以修改很多东西，比如 subkey 的过期时间。
更新之后，会生成新的 sig，可以看 `gpg --list-sigs`。
然后 `gpg --refresh-keys` 就好了。

觉得没用的签名太多，可以 `gpg --edit-key` 然后 `clean` 一下再导出。

---

更新需要的服务器，可以去 https://sks-keyservers.net/overview-of-pools.php 找。
