# git bundle

---

https://git-scm.com/blog/2010/03/10/bundles.html

---

想 copy 一些代码，scp 或者建远程仓库都嫌麻烦，然后想起了 bundle。

```
$ git bundle create <output.bundle> <branch.name>
$ scp <output.bundle> <remote.bundle>
$ git clone <output.bundle>
```

---

其实，也没太多用处……
