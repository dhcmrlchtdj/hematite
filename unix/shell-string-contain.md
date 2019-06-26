# bash start with

---

http://stackoverflow.com/questions/2172352/in-bash-how-can-i-check-if-a-string-begins-with-some-value

---

```
$ a="start-with"
$ [[ $a == *-with ]] && echo 1
```
