# What makes state complex?

---

http://codrspace.com/allenkim67/what-makes-state-complex-/

---

> I think when programmers talk about state and how it introduces complexity,
> it's not very clear what exactly is meant by "state",
> or what causes that complexity.

哈哈哈哈哈哈哈

---

FP 说无状态，无副作用。
那么值在函数间传递，算不算有状态呢？

ELM 说信号是随时间变化的值。
都变化了，肯定有状态对吗？

---

作者说复杂性不是来自数据变化，复杂的是在一个环境里同时管理过去和当前两种状态。

数据在函数间传递，一个函数里只会处理数据的一种状态。
这才是函数式编程能降低复杂度的原因。

---

单向数据流的意义也在于此，将过去的状态和当前的状态分开了。
在特定一次处理中，始终只能看到当前要处理的状态。

---

> If at any point in the flow you persist a store state to access in the
> future you're giving up the benefits of the architecture.

看到最后，发现还是不太懂，还是完全没懂呢……
