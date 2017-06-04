# inheritance is bad

---

https://glyph.twistedmatrix.com/2017/05/the-sororicide-antipattern.html

---

> while inheritance might be bad, composition is worse.

本文在讲组合有哪些问题

---

> Inheritance is bad.
> The primary reason inheritance is bad is confusion between namespaces.

首先讲下继承。
继承的问题来自于命名空间。

---

> It’s important to be able to forget about the internals of the local
> variables in the functions you call.

抽象意味着可以忽略忽略实现的方式，否则这个抽象就是不完全的。
所以命名空间是实现抽象的前提。

---

> Classes complicate this process of forgetting somewhat.

继承的问题在于，让抽象变得困难。

> It’s a bad way for two layers of a system to communicate because it leaves
> each layer nowhere to put its internal state that the other doesn’t need to
> know about.

父类定义了自己的状态，子类也定义了自己的状态。
这些状态来自不同的维度，用于不同的目的。

要保证这些状态不互相影响，意味着子类必须了解父类定义了哪些状态，用来做什么。
将来父类进行修改，子类还要担心状态是否受到影响。

在这里，抽象就不完全了，必须去了解细节了。

---

> The goal of replacing inheritance with composition is to make it clear and
> easy to understand what code owns each attribute on self.

组合的状态使用仍是不清晰的。

如果是 trait 的话，没有状态，就要了解原来有哪些状态。
如果是 mixin 的话，自带状态，就要保证状态直接不冲突。
两者都没解决继承在状态抽象上存在的问题。

---

END

---

https://news.ycombinator.com/item?id=14458608

---

如何解决这个问题？
感觉核心矛盾是命名空间
只要每层抽象都能持有自己的私有引用就可以了？
