# FLIP Your Animations

---

https://aerotwist.com/blog/flip-your-animations/
http://bubkoo.com/2016/03/31/high-performance-animations/

---

很早之前就见过这个文章，但是没留意
逛 HN 看人提到 FLIP，才发现自己之前都没仔细看

---

> FLIP stands for First, Last, Invert, Play.

> - First: the initial state of the element
> - Last: the final state of the element
> - Invert: figure out from the first and last how the element has changed, and then apply transforms and opacity changes to reverse, or invert it
> - Play: remove the inversion changes

```javascript
const first = el.getBoundingClientRect();
el.classList.add('totes-at-the-end');
const last = el.getBoundingClientRect();

const invert = first.top - last.top;
el.style.transform = `translateY(${invert}px)`;

requestAnimationFrame(() => {
    el.classList.add('animate-on-transforms');
    el.style.transform = '';
});

el.addEventListener('transitionend', tidyUpAnimations);
```

先把元素移动到终点，然后用 transform 之类的方式，把元素放回起点。
通过删除 transform，实现移动动画。

---

> Animations that can be remapped to transform and opacity changes are the perfect fit.
