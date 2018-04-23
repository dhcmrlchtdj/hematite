# weakmap key

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap
https://softwareengineering.stackexchange.com/questions/324345/why-cant-an-es2015-weakmap-have-primitive-keys

---

MDN 上说 `Keys of WeakMaps are of the type Object only. Primitive data types as keys are not allowed.`
一开始不太明白为什么，看了下 SO 才发现是这样啊。

---

weakmap 是在对象没有其他引用时，让对象被回收。
而基础数据类型，应该被视为复制而不是引用。
如果用基础数据类型作为 weakmap 的 key，就无法回收了。
