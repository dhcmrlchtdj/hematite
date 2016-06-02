# make nest

---

http://stackoverflow.com/questions/2206128/how-to-call-makefile-from-another-makefile

---

需要在 makefile 里面执行其他 make 的时候。
可以用 `make -C`，比指定文件的 `make -f` 好用，不需要手动切换目录。

```
$ cat Makefile
...
	$(MAKE) -C /path/to/makefile/dir
...
```
