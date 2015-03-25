# regular expression grammar

---

+ http://www.cs.sfu.ca/~cameron/Teaching/384/99-3/regexp-plg.html
+ http://matt.might.net/articles/parsing-regex-with-recursive-descent/

---

```
<re> = <simple-re> "|" <re>

<simple-re> = { <basic-re> }

<basic-re> = <star>
    | <quest>
    | <element-re>

<star> = <element-re> "*"

<quest> = <element-re> "?"

<element-re> = "(" <re> ")"
    | "a-z"
```

---

比较伤脑筋的是 `<simple-re>`，需要计算出 `<basic-re>` 的开始符号，才能使用递归下降来分析。
用 人肉观察法 可以看出，要么是开始符号是 `<element-re>`，凑合着用了。
