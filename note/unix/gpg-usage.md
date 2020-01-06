# gpg usage

---

https://wiki.archlinux.org/index.php/GnuPG
http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto.html
https://www.gnupg.org/gph/en/manual.html
https://alexcabal.com/creating-the-perfect-gpg-keypair/

---

## key

GPG 版本和支持的算法

```
$ gpg --version
```

生成 key

```
$ gpg --expert --full-gen-key
```

查看生成的 key

```
$ gpg --list-keys
$ gpg --list-secret-keys
$ gpg --fingerprint
$ gpg --list-sigs
```

生成 revocation certificate

```
$ gpg --gen-revoke <UID> > <UID>.revoke.asc
```

导出 key

```
$ gpg --armor --export > public_key.asc
$ gpg --armor --export-secret-keys > private_key.asc
```

导入 key

```
$ gpg --import public_key.asc
```

修改 key

```
$ gpg --edit-key <UID>
```

删除 key

```
$ gpg --delete-key <UID>
$ gpg --delete-secret-and-public-keys <UID>
```

---

## usage

加密 / 解密

```
$ gpg --armor --encrypt -u <Sender_UID> -r <Receiver_UID> [DATA]
$ gpg --decrypt [DATA]
```

签名 / 验证

```
$ gpg --armor --sign --detach-sign -u <Sender_UID> [DATA]
$ gpg --verify [DATA]
```

加密签名 / 验证解密

```
$ gpg --armor --sign --encrypt -u <Sender_UID> -r <Receiver_UID> [DATA]
$ gpg --decrypt [DATA]
```

签名信息

```
$ echo "test" | gpg --sign --clearsign
$ echo "test" | gpg --sign --clearsign | gpg --verify
```
