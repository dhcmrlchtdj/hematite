# rust

---

https://rust-unofficial.github.io/too-many-lists/
http://faq.sealedabstract.com/rust/

---

- 变量定义
    - `let x = 1`
    - `let mut x = 1`
- 参数传递
    - `fn by_copy_or_move(x: T) {}`
        - 直接调用时，可能发生 copy 或 move
        - 默认情况是 move
        - 如果 T 满足 Copy trait 则会被 copy
            - 自定义类型定义加上 `#[derive(Copy, Clone)]`
            - copy 可以理解成自动调用了 clone
            - 没实现 copy，也可以手动 clone `by_copy_or_move(x.clone())`
    - `fn by_borrow(x: &T) {}`
        - 只读
    - `fn by_mutable_borrow(x: &mut T) {}`
        - 获得了容器
        - 可以通过 `*x = ...` 修改容器里的 `T`
- 特殊容器
    - `Box<i32>` 不可修改的容器，把值分配到 heap 上，其他和直接 i32 没什么区别
    - `Cell<i32>` 可修改的值容器
        - `let x = Cell::new(0)` 和 `let mut x = 0` 差不多
        - 通过 `x.set(42)` 修改容器内容
    - `RefCell<i32>` 可修改的引用容器
        - 通过 borrow/borrow_mut 获取值的引用，得到 `Ref<i32>`/`RefMut<i32>`
        - 通过 `x.replace(42)` 修改容器内容
        - 通过 `*x.borrow_mut()=42` 修改引用内容
    - `Rc<T>` 允许值有多个 owner 的容器
        - 通过 `Rc::clone(&x)` 新增 owner
        - 可以通过 `*Rc::get_mut(&mut x).unwrap()=42` 修改容器的内容


写上面的时候，还正常。
直到 `fn by_wtf(mut x: RefMut<i32>) {}` 我又感觉接受不了了。
到底怎么理解 mut 这个关键字。

---

- closure

- lifetime
