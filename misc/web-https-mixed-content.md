# HTTPS mixed content

---

https://developer.mozilla.org/en-US/docs/Security/Mixed_content
https://w3c.github.io/webappsec-mixed-content/

---

HTTPS 页面中，请求 HTTP 资源，分为两种情况。

+ `mixed passive/display content` / `Optionally-blockable Content`
    - 纯展示的元素，没有修改页面的能力。
    - 比如 `img(src) / audio(src) / video(src)`
+ `mixed active content` / `Blockable Content`
    - 能够修改页面其他部分，能够接触到 DOM
    - 比如 `script(src) / link(href) / iframe(src) / XMLHttpRequest`

是被白名单，不是 `Optionally-blockable` 的都是 `Blockable`，然后浏览器就会阻止加载。

---

还是有不少尚未明确界定的地方，比如表单的提交、比如 Service Workers 的支持。

总体建议就是，全部走 HTTPS 吧。
