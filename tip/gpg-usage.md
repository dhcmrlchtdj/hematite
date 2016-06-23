# gpg usage

---

https://wiki.archlinux.org/index.php/GnuPG
http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html
https://www.gnupg.org/gph/en/manual.html

---

基本不会用……

```
# 列出 key
$ gpg -k
$ gpg -K
$ gpg --fingerprint
```

```
# 加密数据
$ gpg -a -e -u "Sender Key" -r "Receiver Key" <filename>
$ gpg -a --symmetric <filename>

# 解密数据
$ gpg -d <filename>.asc
```

```
# 签名
$ gpg -a -s -b -u <key> <filename>
$ gpg -a -s <filename>
$ gpg --verify <filename>.asc
```
