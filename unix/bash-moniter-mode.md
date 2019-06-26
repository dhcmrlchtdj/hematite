# bash monitor mode

---

http://stackoverflow.com/questions/690266/why-cant-i-use-job-control-in-a-bash-script
http://stackoverflow.com/questions/32384148/why-does-running-a-background-task-over-ssh-fail-if-a-pseudo-tty-is-allocated/32387290

---

看别人讨论问题学到了……

```
$ ssh host 'set -m; python -m http.server &'
```
