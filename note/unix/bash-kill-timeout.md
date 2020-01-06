# daemon

---

https://stackoverflow.com/questions/687948/timeout-a-command-in-bash-without-unnecessary-delay

---

```bash
(do_something) & pid=$!
(sleep 50 && kill -9 $pid)
wait $pid
```
