# effective ocaml

---

https://blogs.janestreet.com/effective-ml/
https://blogs.janestreet.com/effective-ml-video/
https://blogs.janestreet.com/effective-ml-revisited/
https://blogs.janestreet.com/effective-ml-revisited-with-videos/
https://blogs.janestreet.com/core-principles-uniformity-of-interface/

---

- [ ] Favor readers over writers
    - 不懂
- [.] Create uniform interfaces
    - 不明白
    - 统一，所以易记易用，也易于统一修改，同时不用浪费时间进行特殊的设计
- [.] Make illegal states unrepresentable
    - 不是很明白
    - 每个状态都只包含自己需要的结构
- [x] Code for exhaustiveness
    - 处理所有边缘情况
- [x] Open few modules
    - 少用 `open` 以减少环境污染
- [x] Make common errors obvious
    - 加上 `_exn` 这样的后缀，明确表示会抛出异常
    - 需要特别注意的情况，可以考虑用 `option`
- [ ] Avoid boilerplate
    - 为啥
- [ ] Avoid complex type-hackery
    - 不要定义太复杂的类型？
- [ ] Don't be puritanical about purity
    - 该用就用，不要装纯

---

关于 exn，补充一点。
最近写了一点代码后，确实能感受到这点。
使用异常，就不知道程序到底能不能正常运行。
而使用 option 或者 result 之类的结构，代码的正确性能通过类型检查来保证。
不过传递、拆解时要 match，感觉还是有些繁琐……
