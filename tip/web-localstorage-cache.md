# localstorage cache

---

https://imququ.com/post/enhance-security-for-ls-code.html

---

一直认为 local storage 缓存 js 等静态资源是个不错的主意

---

之前想到的一个问题，是无法对 local storage 进行精确控制。
比如开始使用了某个组件，缓存在 LS 中，后来不再使用了。
此时，脚本完全不知道该组件的存在，更不要说去清理该组件，释放空间了。
一种可选的做法，是在 LS 里面加上访问时间，然后定期清理没有使用的代码。

---

前一段时间看如何存储 JWT 的问题，还没和这个联系起来。
看了文章后才想到 LS 缓存也有安全性的问题。

凡是 JS 能修改的数据，都有被注入修改的风险。
所以，使用 LS 缓存的话，SRI 应该是个很有帮助的特性。
