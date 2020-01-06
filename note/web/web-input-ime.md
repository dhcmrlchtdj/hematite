# input and ime

---

http://blog.evanyou.me/2014/01/03/composition-event/
https://github.com/vuejs/vue/blob/cef724a5f8a7c8dcf2d002314180552e2afe9af7/src/directives/model/text.js#L17
https://developer.mozilla.org/en-US/docs/Web/API/CompositionEvent

---

`input` 碰到输入法的时候，各种 keyup/keydown/input 之类的都有奇怪的表现……
可以用 `CompositionEvent` 配合处理。

在 `compositionstart` 到 `compositionend` 这段时间内，将不需要处理的事件忽略掉。
