# get git modified file in shell

---

```
$ git status -s | awk '$1 ~ /^[AM]/ {print $2}'
$ git status -s | awk '{if ($1 ~ /^[AM]/ && $2 ~ /jsx?$/) print $2}'
```

用 awk 过滤出修改的文件，只能说 awk 博大精深。
