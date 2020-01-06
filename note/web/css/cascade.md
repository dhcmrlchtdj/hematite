+ http://www.w3.org/TR/CSS2/cascade.html

---

## property values

一个样式的最终值，会经过四步计算

1. specified value
2. computed value
3. used value
4. actual value

---

### specified value

+ 如果在样式表中进行了设置，使用样式表
+ 如果属性可继承，使用父元素的 `computed value`。（root 没有父元素就直接下一步了）
+ 使用属性的初始值（来自 css 规范）

---

### computed value

对 specified value 进行解析，得到 computed value
这里进行的解析主要为 url 转换，单位转化等，不涉及页面渲染

---

### used value

必须在页面渲染时才能确定的值，会在这一步进行解析
比如各种百分比

---

### actual value

页面实际使用的值
主要是由于部分 used value 不可用，比如半个像素之类的

---

#### 豆知识

`@import "style.css”` 是 `@import url("style.css")` 的缩写

---

## cascade

---

### cascading order

+ 优先级上 style > id > class > tag > *
+ class 这个级别包括各种属性相关的选择器和伪类
+ tag 这个级别包括伪元素

---

#### 豆知识

`::after` 这种双冒号的写法，是为了把伪元素和单冒号的伪类区别开。
