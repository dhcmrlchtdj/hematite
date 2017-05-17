# prototype-based / class-based

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Details_of_the_Object_Model

---

MDN 里关于 class-based vs. prototype-based 的描述

- class-based 严格区分 class/instance；prototype-based 里全部都是 object
- class-based 在定义 class 时就确定了继承关系；prototype-based 可以动态设置原型链

---

https://tc39.github.io/ecma262/#sec-objects

---

ECMA 规范里的描述

- class-based
    - the state is carried by instances, methods are carried by classes, and inheritance is only of structure and behaviour
    - 状态在实例里，方法在类里；继承的是结构和行为

- prototype-based
    - the state and methods are carried by objects, while structure, behaviour, and state are all inherited.
    - 状态和方法都在对象上；结构、行为、状态都会被继承
