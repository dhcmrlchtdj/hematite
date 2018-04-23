# ignore diff

---

https://medium.com/@porteneuve/how-to-make-git-preserve-specific-files-while-merging-18c92343826b
https://stackoverflow.com/questions/5465122/gitattributes-individual-merge-strategy-for-a-file

---

需求可能比较奇怪。

`build/` 目录不能忽略，必须放在 repo 里面。
合并时又不想处理该目录下的冲突，随便怎么合并都无所谓。

---

想到了 gitattributes，但是不知道具体有哪些玩法 😂，要怎么玩。
看 manpage 也看不太懂，还是搜了下。

---

attribute 里的 merge 能够自定义 merge 的策略。
通过指定不同 driver 使用不同的策略。

```
$ git config --local merge.ours.driver true
$ echo 'build/* merge=ours' >> .gitattributes
```

上面这样的 driver 直接是 true，生成的 diff 是空的。

```
echo 'build/* merge=union' >> .gitattributes
```

自带的 union 这个 driver 会在代码上标记出冲突，但是不会影响合并流程。
