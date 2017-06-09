# ssh host key

---

https://stribika.github.io/2015/01/04/secure-secure-shell.html

---

```
$ ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null
$ ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null
```
