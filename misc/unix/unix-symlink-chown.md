# symlink chown

---

http://superuser.com/questions/68685/chown-is-not-changing-symbolic-link<Paste>

---

```
$ chown -h user:group <link>
```

对于软链接，必须加上 `-h`
