# rust pattern

https://rust-unofficial.github.io/patterns/

---

对我来说，第一条建议最有指导意义。

> use borrowed types (over borrowing the owned type) for arguments
> `&str` over `&String`, `&[T]` over `&Vec<T>`, `&T` over `&Box<T>`

> Using borrowed types you can avoid layers of indirection for those instances where the owned type already provides a layer of indirection
> a `String` has a layer of indirection, so a `&String` will have two layers of indrection.
