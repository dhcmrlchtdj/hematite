# sound

---

https://flow.org/en/docs/lang/types-and-expressions/#toc-soundness-and-completeness
https://softwareengineering.stackexchange.com/questions/140705/what-does-it-mean-to-say-an-algorithm-is-sound-and-complete


---

见过别人说 sound / total，但是不明白什么意思

---

> In type systems, *soundness* is the ability for a type checker to catch every
> single error that *might* happen at runtime.

对类型系统来说，sound 就是说可以在编译时检查出所有类型错误。
代价就是可能会查出一些在执行时不可能出现的情况，然后报错要求处理。


> *completeness* is the ability for a type checker to only ever catch errors
> that *would* happen at runtime.

complete 说的是，这什么区别呢……

---

> In an ideal world, every type checker would be both sound and complete so
> that it catches every error that will happen at runtime.

如果可以的话，应该同时做到 sound 和 complete。

---

> Soundness says that if an answer is returned that answer is true.
> Completeness says that an answer is true if it is returned.

懵……
