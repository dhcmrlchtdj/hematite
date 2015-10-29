# ssh config order

---

manpage

---

> Since the first obtained value for each parameter is used, more host-specific
> declarations should be given near the beginning of the file, and general
> defaults at the end.

ssh 读取配置的时候，只认第一次读到的值。
所以要把 `Host *` 放在最后才能实现对单个服务器进行特殊配置。

---

```
Host a
    xxx

Host b
    yyy

Host *
    zzz
```
