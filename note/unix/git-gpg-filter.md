# gpg filter

---

用 beancount 记账的时候，想对内容加密。
可以使用 https://github.com/AGWA/git-crypt 之类的工具。
不过直接 filter 好像也可以的吧？

---

https://gist.github.com/g-k/9087422
https://gist.github.com/sandeepraju/4934282f5f87c83ddd93

```
$ cat .git/config
[filter "gpg"]
    clean = "gpg --no-tty --quiet --encrypt -u <USER-ID> -r <USER-ID>"
    smudge = "gpg --no-tty --quiet --decrypt -u <USER-ID>"
    required
[diff "gpg"]
    textconv = "cat"
    binary
    ; cachetextconv = true

$ cat .gitattributes
*.bean filter=gpg
*.bean diff=gpg
```

不加上 `diff=gpg` 的话，diff 时就只能看加密后的数据了。
试了好久才发现 `textconv=cat` 才是正确的做法。

流程上，数据先 `gpg.clean` 到了 git 内部。
没有 `diff=gpg` 的话，应该是直接对比 git 存储的数据。
加上 `diff=gpg` 之后，数据会先 `gpg.smudge` 出来，再交给 `gpg.textconv`。
之前一直试着在 `gpg.textconv` 再 decrypt 一次，其实是没必要的，直接输出就行。

缺点，就像前面 gist 说的那样，即使什么都没修改，还是会因为 gpg 的关系产生 diff。
从这点来看，git 的内容确实不适合使用 gpg 加密？
直接使用 AEAD 来加密，问题又变成了密钥管理。
