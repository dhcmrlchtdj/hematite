# find binary

---

http://superuser.com/questions/614921/how-to-detect-from-where-application-has-started

---

```
$ readlink /proc/$PID/exe
$ cat /proc/$PID/cmdline
$ readlink /proc/$PID/cwd
```
