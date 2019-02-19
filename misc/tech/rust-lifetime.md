# rust lifetime

---

https://stackoverflow.com/questions/57483

先插入一点别的东西，`pointer` 和 `reference` 区别是什么呢？

- 首先，reference 是 alias
- reference 是概念，pointer 是实现细节
- reference 的指向是不可变的，只能指向某个固定的地址；pointer 没有限制
- reference 必须指向某个存在的对象；pointer 没有限制
- 没有 reference 的 reference；有 pointer 的 pointer
- 没有 reference arithmetic；有 pointer arithmetic

上面这些是对 C++ 的描述（我也不知道对不对……
但至少，rust 中是有 reference 的 reference 的。

在 rust 中，除了传递参数的时候，感觉 reference 和普通对象没什么区别。

---

https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html
https://doc.rust-lang.org/rust-by-example/scope/lifetime.html
https://doc.rust-lang.org/stable/std/primitive.reference.html

> - a lifetime is used to ensure all borrows are valid
> - every reference has a lifetime, which is the scope that reference is valid
> - a reference is just a pointer that is assumed to not be null
> - references can be used much like the original value

- 我倾向使用 copy/move 而不是 borrow，减少 lifetime 的问题……
- 用到 reference 的时候，都应该留意下 lifetime 是不是符合预期。
