# closure conversion

---

http://matt.might.net/articles/closure-conversion/

---

## flat closures

bottom-up closure conversion

- variables are copied when a closure is created
- 空间换时间

## shared closures

top-down closure conversion

- accesses to variables get chained through outer environments
- 时间换空间

---

不管哪种方式，都是把 free variable 变成了 argument。
完成 closure conversion 之后，closure 里没有了 free variable，就可以全部 hoist to the top level。（也就是 lambda-lifting

把 free variable 改写成 argument 之后，函数内部对变量的引用也要改写成对应的形式。（一个 pass 的事情

