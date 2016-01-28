# css transform fixed

---

https://drafts.csswg.org/css-transforms/

---

> For elements whose layout is governed by the CSS box model, any value other
> than none for the transform results in the creation of both a stacking
> context and a containing block. The object acts as a containing block
> for fixed positioned descendants.

`positione:fixed` 默认的 containing block 是 viewport。
如果其父节点设置了 `transform`，那么 containing block 就不在是 viewport，而是这个父节点了。
