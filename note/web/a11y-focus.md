# focus

很久没有写东西了，最近碰到一个之前没想到的问题。
页面可用性要好，要加上 tabIndex。
但是有了 tabIndex，会导致鼠标点击时触发 focus 样式，还不会自动消失，这就很不好看了。
能不能支持 tab 触发 focus，但 click 不触发呢？
想不出解决方案，搜了很久才在万能的 stackoverflow 找到一个方案。

https://stackoverflow.com/a/45191208

---

```html
<div tabindex="0">
    <p>tabIndex=none</span>
    <p tabindex="0">tabIndex=0</span>
    <p tabindex="-1">tabIndex=-1</span>
</div>

<style>
div:focus {
    outline: 2px solid red;
}
p:focus {
    outline: 1px solid blue;
}
</style>
```

键盘 tab 可以正确展示 `div` 的 focus 样式。
鼠标点击 `p[tabindex]` 时不会触发 `div` 的 focus 样式。

有 tabindex 就不会在 click 时触发上层的 focus，主要是了解浏览器这个逻辑。
