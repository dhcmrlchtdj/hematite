# font loading

---

https://www.zachleat.com/web/comprehensive-webfonts/

---

> SVG is probably a better long term choice.

开头就建议不要用 font，该用 SVG……

就个人目前使用场景来看，更多是为了 icon font 而加载字体。
而 SVG 在调整 icon 大小时并不方便，所以个人还是倾向于 icon 的场景使用 font。

---

![strategies](./web-font-loading.svg)

---

+ font-face
	- 不建议使用
+ font-display
	- 可以加上，但是很多浏览器还没实现
+ preload
	- 可以加上，配合 font-face 和 font-display
+ don’t use web fonts
	- 哈哈哈
+ inline data uri
	- 不要这么搞，用 FOUT 代替
+ asynchronous data uri stylesheet
	- 这方法可以，不过下面有更好的方法
+ FOUT with a class
	- 大部分情况下，这个是比较好的选择
+ FOFT, or FOUT with two stage render
	- 可以更好
+ critical FOFT
	- 可以再优化
+ critical FOFT with data uri
	- 当前环境下的最佳方案
+ critical FOFT with preload
	- 浏览器对 preload 的支持增强后，这个会是更优的方案
