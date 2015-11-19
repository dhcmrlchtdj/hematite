# npm reinstall global

---

https://gist.github.com/othiym23/4ac31155da23962afd0e

---

```
$ npm ls -g --depth 0 2>/dev/null | cut -d '@' -f 1 -s | tr -d '├──└ ' | tr '\n' ' '
```
