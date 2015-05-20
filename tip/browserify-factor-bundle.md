# factor bundle

---

试用了一下 `factor-bundle`，感觉上有点糟糕。

---

比如 A(X, Y) B(X, Z) C(Y, Z)，页面 ABC 依赖于模块 XYZ。
使用 factor-bundle 打包时，会被拆分为 A, B, C, XYZ 四个包。
实际使用中，A 页面要加载不需要的 Z。页面越多，这里的 XYZ 就会越大。
