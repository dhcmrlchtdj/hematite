# the little mler

---

## preface

---

> goal
> 1. think recursively about types and programs.
> 2. dealing with exceptional situations and composing program components.

- 前八章都在讲第一点，关于类型的递归、程序的递归
- 最后讲异常和组合

---

## 1. building blocks

---

> a type is a name for a collection of values.

---

- 上来就泛型……

---

### first moral

> use datatype to describe types.
> when a type contains lots of values, the datatype definition refers to itself.
> use 'a with datatype to define shapes.

- 类型定义

---

## 2. matchmaker, matchmaker

---

- （看过前几本，作者例子都懒得想了……
- 组合类型
- 模式识别

---

### second moral

> the number and order of the patterns in the definition of a function should
> match that of the definition of the consumed datatype.

- 要把所有边缘情况处理掉

---

## 3. cons is still magnificent

---

- 会感觉模式识别是个非常自然的事情

---

### third moral

> functions that produce values of a datatype must use the associated
> constructors to build data of that type.

---

## 4. look to the stars

---

- 讲 tuple
- （1. 原来这里的 star 是类型定义的 star；
- （2. 接下去就能玩 ADT 了？
- 论模式匹配中通配符的重要性……

---

### fourth moral

> some functions consume values of star type; some produce values of star type.

---

## 5. couples are magnificent, too

---

- 还是前面的内容，模式识别，类型定义

---

### fifth moral

> write the first draft of a function following all the morals.
> when it is correct and no sooner, simplify.

先正确，再优化

---

## 6. oh my, it's full of stars!

---

- （之前就有一直异样感，现在想来是因为 ocaml 里用自定义类型时，经常要把类型带上的关系？

---

### sixth moral

> as datatype definitions get more compicated, so do the functions over them.

没明白什么意思

---

## 7. functions are people, too

---

### seventh moral

> some functions consume values of arrow type; some produce values of arrow type.

高阶函数

---

## 8. bows and arrows

---

### eighth moral

> replace stars by arrows to reduce the number of values consumed and to
> increase the generality of the function defined.

我能想到的有单参数、多参数，自动科里化

---

## 9. Oh No!

---

### ninth moral

> some functions produce exceptions instead of values; some don't produce
> anything.
> handle raised exceptions carefully.

（感觉什么都没说呀……
empty 会让人想到 option

---

## 10. Building On Blocks

---

- 讲 module

---

### tenth moral

> real programs consist of many components.
> specify the dependencies among these components using signatures and functors.

在作者看来，functor 和 'a 差不多，所以不觉得难吧……

---

## summary

囫囵吞枣。
什么都没看进去……
