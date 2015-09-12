# git server hook

+ https://www.atlassian.com/git/tutorials/git-hooks/server-side-hooks

---

看了下 git server hook，比较奇怪的地方是没有使用参数，而是使用 stdin 来传递数据。

```sh
# server / post-receive

read oldrev newrev ref
echo "$oldrev $newrev $ref" >> receive.log
```

```sh
# client / prepare-commit-msg

echo "$1 $2 $3" >> commit-msg.log
```
