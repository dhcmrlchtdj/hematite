# viewport

+ http://www.quirksmode.org/mobile/metaviewport/
+ https://github.com/amfe/lib-flexible/blob/master/src/flexible.js

---

+ `width`
+ `initial-scale`
+ `minimum-scale`
+ `maximum-scale`
+ `user-scalable`

---

+ 获取页面宽度可以用 `document.documentElement.clientWidth`
+ ios 下，使用 `screen.width` 拿到的始终是 `portrait` 下的宽度，拿不到 `landscape` 时的宽度。

---

`initial-scale` 会设置宽度，有了 `initial-scale` 就不需要 `width` 了。

+ 在 android 下，`initial-scale` 只能设置为 `1`。
+ 在 android 下，`initial-scale` 和 `width` 同时存在时，最小值为 `device-width`，超过时以 `width` 为准。
+ 其他环境中，两者同时存在时，实际宽度会取两者中较大的一个。

---

```js
(function() {
    var isIPhone = window.navigator.appVersion.match(/iphone/i);
    var devicePixelRatio = window.devicePixelRatio;
    var dpr = 1;
    if (isIPhone) {
        if (devicePixelRatio >= 3) {
            dpr = 3;
        } else if (devicePixelRatio >= 2) {
            dpr = 2;
        }
    }
    var scale = 1 / dpr;

    var metaViewport = '<meta name="viewport" content="initial-scale=' + scale + '" />';
    document.write(metaViewport);

    var docEl = document.documentElement;
    //var width = docEl.getBoundingClientRect().width;
    var width = docEl.clientWidth;
    if (width / dpr > 450) width = dpr * 450;
    var rem = width / 6.4;
    docEl.style.fontSize = rem + 'px';
})();
```
