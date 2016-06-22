# gpg usage

---

https://wiki.archlinux.org/index.php/GnuPG

---

基本不会用……

```
# 列出 key
$ gpg -k
$ gpg -K

# 加密解密文件
$ gpg -e -a -r <key> <filename>
$ gpg <filename>.asc

# 签名
$ gpg -s -b -a -u <key> <filename>
$ gpg --verify <filename>.asc
```
