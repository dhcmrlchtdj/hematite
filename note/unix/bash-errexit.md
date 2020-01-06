# bash errexit

---

http://wiki.bash-hackers.org/commands/builtin/set

---

`-e` 可以在脚本出错的时候，停止执行，返回错误。

```bash
#!/bin/bash
set -e
```

使用 `set +e` `set -e` 可以在局部开关该功能。
