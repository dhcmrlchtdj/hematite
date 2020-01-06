# python site packages

---

https://docs.python.org/2.7/library/site.html

---

在用 electron 给一个 python 程序写 GUI 的时候，考虑把 python 程序和相关依赖都一起打包进去，
免得用户还要自己安装依赖。

查了一下，可以用 `PYTHONUSERBASE`。

---

```
$ pip install --prefix ./deps
$ python -m site --user-site
$ PYTHONUSERBASE=./deps python -m site --user-site
```

看一下输出的路径，正确指向 `site-packages` 的话就没问题啦。
