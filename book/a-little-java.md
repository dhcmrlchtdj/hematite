# a little java a few patterns

---

## perface

---

会介绍两方面的内容，java 的面向对象编程和设计模式
- object-oriented: (abstract) classes, fields, methods, inheritance, interfaces
- design patterns: key elements of a programming discipline that enhances code reuse

---

> Do not rush through this book. Allow seven sittings, at least. Read carefully.
哈哈哈

---

## modern toys

---

> The First Bit of Advice
> When specifying a collection of data, use abstract classes for
> datatypes and extended classes for variants.

- **abstract class** introduces a datatype
- **class** introduces a variant
- **extends** connects a variant to a datatype

---

用 `new Zero()` 和 `new OneMoreThan(num)` 来构造数字
是不是让人想到 church encoding

---

> are types just names for different collections with no common instances?
> the primitive types are distinct; others may overlap.

---

## methods to our madness

---

concrete method 实现 abstract method 被作者称为义务（

---

> The Second Bit of Advice
> when writing a function over a datatype, place a method in each of the
> variants that make up the datatype. If a field of a variant belongs to the
> same datatype, the method may call the corresponding method of the field in
> computing the function.

---

这章主要都是 java 编程的知识。
关键是 abstract 定义 datatype

---

## what's new

---


