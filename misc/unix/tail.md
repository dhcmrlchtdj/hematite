# tail

---

```
$ tail -f logfile.log | cut -b -$(tput cols)
```

`tail` 不像 `less -S` 可以截断，只能自己用 `cut` 来辅助。
不过遇到某些特殊字符时，输出会有问题。
