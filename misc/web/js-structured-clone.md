# structured clone algorithm

---

https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm

---

之前记得见过这个，后来又一直找不到，今天又突然看到了。

---

和 JSON 相比

- 支持一些 JSON 不支持的数据类型
- 支持循环引用
- 更高效

和 JSON 一样有些限制

- 不支持 Error / Function / DOM
- 部分属性会丢失，比如原型链上的信息、property descriptor 等
