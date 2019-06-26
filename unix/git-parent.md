# git ancestor of two branch

---

http://stackoverflow.com/questions/1549146/find-common-ancestor-of-two-branches
http://stackoverflow.com/questions/3697178/git-merge-all-changes-from-another-branch-as-a-single-commit

---

```
$ git merge-base HEAD master
```

在处理 `rebase` 冲突时，先找到共同祖先然后 squash 一下算个可选方案
`man git-merge-base` 最后也是个 `rebase` 的例子

---

先 `merge --squash` 再 `rebase` 也许也是个方案？
