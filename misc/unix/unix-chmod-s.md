# chmod

---

http://permissions-calculator.org/info/

---

```
$ ll /usr/bin/passwd
-rwsr-xr-x 1 root root 49K yyyy-mm-dd HH:MM /usr/bin/passwd*
```

可以看到不是 `rwx` 而是 `rws`
执行 `passwd` 的时候，会以 `root` 的权限执行

---

需要修改的话，使用 `u+s`，对应的八进制为 `4000`。
