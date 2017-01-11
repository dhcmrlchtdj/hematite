
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

## 1. modern toys

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

## 2. methods to our madness

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

## 3. what's new?

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

## 4. come to our carousel

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

## 5. objects ara people, too

---

还是在讲 java 的面向对象
overriding / downward casting

---

## 6. boring protocols

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

## 7. oh my!

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

## 8. like father, like son

---

作者对 s-exp 爱得深沉……

---

讲 visitor 之间的继承关系

---

先定义数据，加减乘的表达式

```java
abstract class ExprD {
	abstract Object accept(ExprVisitorI ask);
}
class Plus extends ExprD {
	ExprD l;
	ExprD r;
	Plus(ExprD _l, ExprD _r) { l = _l; r = _r; }
	Object accept(ExprVisitorI ask) { return ask.forPlus(l, r); }
}
class Diff extends ExprD {
	ExprD l;
	ExprD r;
	Diff(ExprD _l, ExprD _r) { l = _l; r = _r; }
	Object accept(ExprVisitorI ask) { return ask.forDiff(l, r); }
}
class Prod extends ExprD {
	ExprD l;
	ExprD r;
	Prod(ExprD _l, ExprD _r) { l = _l; r = _r; }
	Object accept(ExprVisitorI ask) { return ask.forProd(l, r); }
}
class Const extends ExprD {
	Object c;
	Const(Object _c) { c = _c; }
	Object accept(ExprVisitorI ask) { return ask.forConst(c); }
}
```

再定义 visitor protocol

```java
interface ExprVisitorI {
	Object forPlus(ExprD l, ExprD r);
	Object forDiff(ExprD l, ExprD r);
	Object forProd(ExprD l, ExprD r);
	Object forConst(ExprD l, ExprD r);
}
```

实现两种 visitor，先是 int visitor

```java
class IntEvalV implements ExprVisitorI {
	public Object forPlus(ExprD l, ExprD r) {
		return plus(l.accept(this), r.accept(this));
	}
	public Object forDiff(ExprD l, ExprD r) {
		return diff(l.accept(this), r.accept(this));
	}
	public Object forProd(ExprD l, ExprD r) {
		return prod(l.accept(this), r.accept(this));
	}
	public Object forConst(Object c) {
		return c;
	}

	Object plus(Object l, Object r) {
		return new Integer(((Integer)l).intValue() + ((Integer)r).intValue());
	}
	Object diff(Object l, Object r) {
		return new Integer(((Integer)l).intValue() - ((Integer)r).intValue());
	}
	Object prod(Object l, Object r) {
		return new Integer(((Integer)l).intValue() * ((Integer)r).intValue());
	}
}
```

前面也说过，使用 Object 带来了灵活性，但是也让代码更繁琐。
这里进行了大量的基础类型和对象类型的转换

此外，继续实现 set visitor 的时候，前面的 forXXX 都要重复一次
所以作者选择了使用继承

前面的 Integer 是自带的，下面先实现一个 SetD
（这里其实也有个继承在

```java
abstract class SetD {
	SetD add(Integer i) { return (mem(i) ? this : new Add(i, this)); }

	abstract boolean mem(Integer i);
	abstract SetD plus(SetD s);
	abstract SetD diff(SetD s);
	abstract SetD prod(SetD s);
}
class Empty extends SetD {
	boolean mem(Integer i) { return false; }
	SetD plus(SetD s) { return s; }
	SetD diff(SetD s) { return new Empty(); }
	SetD prod(SetD s) { return new Empty(); }

}
class Add extends SetD {
	Integer i;
	SetD s;
	Add(Integer _i, SetD _s) { i = _i; s = _s; }

	boolean mem(Integer n) { return (i.equals(n) ? true : s.mem(n)); }
	SetD plus(SetD t) { return s.plus(t.add(i)); }
	SetD diff(SetD t) { return (t.mem(i) ? s.diff(t) : s.diff(t).add(i)); }
	SetD prod(SetD t) { return (t.mem(i) ? s.prod(t).add(i) : s.prod(t)); }
}
```

然后就是 set visitor

```java
class SetEvalV extends IntEvalV {
	Object plus(Object l, Object r) { return ((SetD)l).plus((SetD)r); }
	Object diff(Object l, Object r) { return ((SetD)l).diff((SetD)r); }
	Object prod(Object l, Object r) { return ((SetD)l).prod((SetD)r); }
}
```

对比一下 SetEvalV 和 IntEvalV，省去了重复 forXXX
再和前面的 PieVisitorI 的实现对比一下，其实是把实现从 forXXX 里提取了出来
着眼点应该还是将逻辑从形式中分开，可以看到 forXXX 里面是可以不处理类型转换的

最后上个使用的例子

```java
new Prod(
	new Const(new Empty().add(new Integer(7))),
	new Const(new Empty().add(new Integer(3)))
).accept(new SetEvalV());
```

---

继续对上面的继承关系做优化

```java
abstract class EvalD implements ExprVisitorI {
	public Object forPlus(ExprD l, ExprD r) {
		return plus(l.accept(this), r.accept(this));
	}
	public Object forDiff(ExprD l, ExprD r) {
		return diff(l.accept(this), r.accept(this));
	}
	public Object forProd(ExprD l, ExprD r) {
		return prod(l.accept(this), r.accept(this));
	}
	public Object forConst(Object c) {
		return c;
	}

	Object plus(Object l, Object r);
	Object diff(Object l, Object r);
	Object prod(Object l, Object r);
}

class IntEvalV extends EvalD {
	Object plus(Object l, Object r) {
		return new Integer(((Integer)l).intValue() + ((Integer)r).intValue());
	}
	Object diff(Object l, Object r) {
		return new Integer(((Integer)l).intValue() - ((Integer)r).intValue());
	}
	Object prod(Object l, Object r) {
		return new Integer(((Integer)l).intValue() * ((Integer)r).intValue());
	}
}

class SetEvalV extends EvalD {
	Object plus(Object l, Object r) { return ((SetD)l).plus((SetD)r); }
	Object diff(Object l, Object r) { return ((SetD)l).diff((SetD)r); }
	Object prod(Object l, Object r) { return ((SetD)l).prod((SetD)r); }
}
```

把对 IntEvalV 的继承修改为对 EvalD 的继承，将需要复用的部分抽离
看代码确实更清爽了些（不过好像也确实越来越复杂了

---

> the eighth bit of advice
> when extending a class, use overriding to enrich its functionality.

这章主要是在介绍面向对象的继承技术
不过之前说的，使用多态带来的问题，仍然是问题。

---

## 9. be a good visitor

---

介绍了
super 关键字
对 interface 的继承

---

```java
class Union extends ShapeD {
	ShapeD s;
	ShapeD t;
	Union(ShapeD _s, ShapeD _t) { s = _s; t = _t; }
	boolean accept(ShapeVisitorI ask) {
		return ((UnionVisitorI)ask).forUnion(s, t);
	}
}
```

此处将 ShapeVisitorI 转换为 UnionVisitorI，感觉不合适啊
子类变成父类，肯定可以
父类变成子类，可能失败呀

不过很巧妙的一点
虽然 Union 里面都是 Shape
但调用 ShapeVisitorI 里的方法时，都是 Shape 主动调用 visitor
所以即使类型是父类 Shape，还是可以调用到正确的 visitor

---

> the ninth bit of advice
> if a datatype may have to be extended, be forward looking and use a
> consturctor-like (overridable) method so that visitors can be extended, too.

不太好理解
作者说这其实是 factory method pattern

---

```java
class HasPtV implements ShapeVisitorI {
	PointD p;
	HasPtV(PointD _p) { p = _p; }

	public boolean forCicle(int r) {...}
	public boolean forSquare(int s) {...}
	public boolean forTrans(PointD q, ShapeD s) {
		return s.accept(new HasPtV(p.minus(q)));
	}
}
```

```java
class HasPtV implements ShapeVisitorI {
	PointD p;
	HasPtV(PointD _p) { p = _p; }
	ShapeVisitorI newHasPt(PointD p) { return new HasPtV(p); }

	public boolean forCicle(int r) {...}
	public boolean forSquare(int s) {...}
	public boolean forTrans(PointD q, ShapeD s) {
		return s.accept(newHasPt(p.minus(q)));
	}
}

class UnionHasPtV extends HasPtV implements UnionVisitorI {
	UnionHasPtV(PointD _p) { super(_p); }
	ShapeVisitorI newHasPt(PointD p) { return new UnionHasPtV(p); }

	public boolean forUnion(ShapeD s, ShapeD t) {
		return (s.accept(this) || t.accept(this));
	}
}
```

这里定义的 `newHasPt`，只是封装了一下构造函数
也就是前文说的 consturctor-like method

关键在 `forTrans` 里面的调用
上面的代码直接进行 `new HasPtV`，使得 `UnionHasPtV` 的信息丢失
下面的代码，使用了 `newHasPt`，使得代码的可扩展性变得更强了

---

在需要保留扩展性的地方，不要硬编码，而是使用更加可扩展的方式编写

---

## 10. the state of things to come

---



