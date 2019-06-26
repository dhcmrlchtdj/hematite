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

---

http://dmitrysoshnikov.com/ecmascript/chapter-7-1-oop-general-theory/
https://medium.com/@DmitrySoshnikov/oo-relationships-5020163ab162

---

> statics + classes vs. dynamics + prototypes

作者明确区分了下 static 和 dynamic。

---

### static class based model

- define class before create object
    - classe define strict unchangeable structure and strict unchangeable behavior
    - object store state
- classe extend other classe
    - methods are not copied into a class-descendant but form hierarchy
    - properties are always copied
- static
    - class cannot change properties / methods of their instances
    - instances cannot have additional properties / behaviors

---

### dynamic prototype based model

- any object can be used as a prototype of another object
    - prototype chain: prototype can have their own prototype
- dynamic
    - mutable object
    - object can change its prototype at runtime
- model
    - concatenative prototype model
        - copy prototype at the moment object created
    - delegation based model
        - no copy

---

## dynamic class based model

- dynamic
    - object cannot change its class at runtime
    - augment class affects all instances

---

## OOP feature

- polymorphism
    - parametric polymorphism
    - duck typing
- encapsulation
    - encapsulation is an increasing of abstraction
- multiple-inheritance
    - mixins
        - in JS, copies all properties of the module into an object
    - traits
        - vs mixin: trait should not have a state
        - in JS, copies all properties of the module into an object
    - interfaces
        - in JS, object throwing an exception in methods
    - composition
        - via mixins or traits
    - AOP
        - function decorators
        - in JS, high order function
