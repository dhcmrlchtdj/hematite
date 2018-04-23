# chrome devtool copy

---

http://superuser.com/questions/699922/can-i-prevent-chrome-from-truncating-strings-in-the-dev-console

---

chrome 在打印长字符串的时候，会进行截断。
这点很讨厌，让复制之类的操作变得很不方便。

搜了下才知道原来有个 `copy` 函数。

SO 上给出的其它方法还有 `console.dir` 和 `window.prompt`。
直接复制的话，还是 `copy` 方便就是了。
