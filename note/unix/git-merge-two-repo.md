# merge two repo

https://stackoverflow.com/a/14470212

关键是 `--allow-unrelated-histories`

```
$ git remote add -f repo_x <url>
$ git merge repo_x/master --allow-unrelated-histories
```
