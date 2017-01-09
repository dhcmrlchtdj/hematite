
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

superscript

D - a datatype
V - a visitor class
I - an interface
M - manage a data structure

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

## what's new?

---

> The Third Bit of Advice
> When writing a function that returns values of a datatype,
> use new to create these values.

这个只是作者个人的编程习惯，还是有确实的好处呢

---

看着每个 class 都要实现一下 abstract method
突然想到了 ramda 对 lodash 的批评，compose 比 chain 要更优雅

---

新增 class 是比较廉价的，只要实现全部 abstract 即可。
但扩展 abstract 是非常昂贵的，所有 class 都需要一起更新。

牺牲 abstract 的扩展性换来了新增 class 的便利。

---

## come to our carousel

---

问题在哪里？

> it becomes more and more difficult to understand the rationale for each of
> the methods in a variant and what the relationship is between methods of
> the same name in the different variants.

- 不同 class 之间，同名 method 是什么关系
- 同一 class 之内，不同 method 是什么关系

随着 method 越来越多，这两个问题越来越难回答

---

如何处理？

不在 abstract class 里定义 abstract method
而是在外部定义 visitor

---

> it would be much easier to understand what action these methods perform

> separate the action from the datatype

把 method 集中在 visitor 里，而不是分散在各个 class 中
能让该 method 的功能变得一目了然
同时把行为和数据分离开了

---

对比一下前后的代码

```java
abstract class ShishD {
	abstract boolean onlyOnions();
}

class Skewer extends ShishD {
	boolean onlyOnions() { return true; }
}
class Onion extends ShishD {
	ShishD s;
	Onion(ShishD _s) { s = _s; }
	boolean onlyOnions() { return s.onlyOnions() }
}
class Lamb extends ShishD {
	ShishD s;
	Lamb(ShishD _s) { s = _s; }
	boolean onlyOnions() { return false; }
}
class Tomato extends ShishD {
	ShishD s;
	Tomato(ShishD _s) { s = _s; }
	boolean onlyOnions() { return false; }
}
```

```java
class OnlyOnionsV {
	boolean forSkewer() { return true; }
	boolean forOnion(ShishD s) { return s.onlyOnions(); }
	boolean forLamb(ShishD s) { return false; }
	boolean forTomato(ShishD s) { return true; }
}

abstract class ShishD {
	OnlyOnionsV ooFn = new OnlyOnionsV();
	abstract boolean onlyOnions();
}

class Skewer extends ShishD {
	boolean onlyOnions() { return ooFn.forSkewer(); }
}
class Onion extends ShishD {
	ShishD s;
	Onion(ShishD _s) { s = _s; }
	boolean onlyOnions() { return ooFn.forOnion(s); }
}
class Lamb extends ShishD {
	ShishD s;
	Lamb(ShishD _s) { s = _s; }
	boolean onlyOnions() { return ooFn.forLamb(s); }
}
class Tomato extends ShishD {
	ShishD s;
	Tomato(ShishD _s) { s = _s; }
	boolean onlyOnions() { return ooFn.forTomato(s); }
}
```

作者将 abstract class 里面的 visitor 称为 protocol

怎么感觉更繁琐了呢……
之前不好扩展的问题，感觉没有变化啊
作者自己都说这是一个无聊的过程啊（boring
而且感觉各个部分耦合好严重

---

> the fourth bit of advice
> when writing severval functions for the save self-referential datatype,
> use visitor protocols so that all methods for a function can be found in
> a single class.

---

## objects ara people, too

---

还是在讲 java 的面向对象
overriding / downward casting

---

## boring protocols

---

```java
class OnlyOnionsV {
	boolean forSkewer() { return true; }
	boolean forOnion(ShishD s) { return s.onlyOnions(); }
	boolean forLamb(ShishD s) { return false; }
	boolean forTomato(ShishD s) { return true; }
}

abstract class ShishD {
	abstract boolean onlyOnions(OnlyOnionsV ooFn);
}

class Skewer extends ShishD {
	boolean onlyOnions(OnlyOnionsV ooFn) { return ooFn.forSkewer(); }
}
class Onion extends ShishD {
	ShishD s;
	Onion(ShishD _s) { s = _s; }
	boolean onlyOnions(OnlyOnionsV ooFn) { return ooFn.forOnion(s); }
}
class Lamb extends ShishD {
	ShishD s;
	Lamb(ShishD _s) { s = _s; }
	boolean onlyOnions(OnlyOnionsV ooFn) { return ooFn.forLamb(s); }
}
class Tomato extends ShishD {
	ShishD s;
	Tomato(ShishD _s) { s = _s; }
	boolean onlyOnions(OnlyOnionsV ooFn) { return ooFn.forTomato(s); }
}
```

相比前面，改成外部传入 OnlyOnionsV

visitor 提供的方法被称为 service
这就是依赖注入吗？

用参数的方式传递 OnlyOnionsV，使得扩展 OnlyOnionsV 变得容易了
但是扩展 abstract class 还是要每个 class 实现一遍

---

> in functional programming, a visitor with fields is called a closure (or a
> higher-order function)

到底什么算闭包，什么算高阶函数，之前的理解还是太片面啊

---

> use interface for specifying visitors

```java
interface PieVisitorI {
	PieD forBot();
	PieD forTop(Object t, PieD r);
}
class RemV implements PieVisitorI {
	Object o;
	RemV(Object _o) { o = _o; }

	public PieD forBot() { return new Bot(); }
	public PieD forTop(Object t, PieD r) {
		if (o.equals(t)) {
			return r.accept(this);
		} else {
			return new Top(t, r.accept(this));
		}
	}
}
class SubstV implements PieVisitorI {
	Object n;
	Object o;
	SubstV(Object _n, Object _o) { n = _n; o = _o; }
	public PieD forBot() { return new Bot(); }
	public PieD forTop(Object t, PieD r) {
		if (o.equals(t)) {
			return new Top(n, r.accept(this));
		} else {
			return new Top(t, r.accept(this));
		}
	}
}

abstract class PieD {
	abstract PieD accept(PieVisitorI ask);
}
class Bot extends PieD {
	PieD accept(PieVisitorI ask) { return ask.forBot(); }
}
class Top extends PieD {
	Object t;
	PieD r;
	Top(Object _t, PieD _r) { t = _t; r = _r; }
	PieD accept(PieVisitorI ask) { return ask.forTop(t, r); }
}
```

定义好的 datatype 带有 accept 方法，接受一个 visitor
不同的逻辑，放到不同的 visitor 中去实现

---

> the sixth bit of advice
> when the additional consumed values change for a self-referential use of a
> visitor, don't forget to create a new visitor.

---

## oh my!

---

还是前面的 interface 和 visitor，举了些例子。
实现了最初扩展 datatype 的目的。

---

介绍了一下 polymorphism

在 java 里面，实现 visitor 的多态需要在 datatype 里为需要的类型重复定义方法
显得比较麻烦，文中是返回值类型不同的情况，参数不同的情况应该也是一样的
动态语言的 ducktype 在这种场景下还是有优势的

然后，书中的解决方案是，返回值全部都用 Object 而不是具体类型
🙄️，感觉这样不太好啊，失去了静态检查的优势？
返回基本类型时，逻辑代码也变得更复杂了
另外，前面说到的参数不同的问题，也不能靠 Object 来解决
（虽然这里的 visitor 不会涉及到不同参数的情况

---

> the seventh bit of advice
> when designing visitor protocols for many different types, create a unifying
> protocol using Object.

---

## like father, like son

---

作者对 s-exp 爱得深沉……

---


