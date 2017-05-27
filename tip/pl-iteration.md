# Iteration Inside and Out

---

http://journal.stuffwithstuff.com/2013/01/13/iteration-inside-and-out/

---

> iteration involves two chunks of code:
> one generating values, and one consuming them

遍历包含两个部分，生产者和消费者。

作者讲了 external iterator 和 internal iterator 两种处理策略。
看完的感觉像是 OO 和 FP？

---

external 说的是 for 循环。
类型自己实现 iterator protocol，然后被遍历。
对数据源来说，是个被拉取的过程。

```javascript
const elements = [1, 2, 3, 4, 5];
let __iterator = elements.iterator();
while (__iterator.moveNext()) {
    const i = __iterator.current;
    console.log(i);
}
```

---

internal 说的是 foreach 这种高阶函数。
类型接收一个处理函数，然后主动去调用这个处理函数。
对数据源来说，是个推送的过程。

```javascript
beatles = ['George', 'John', 'Paul', 'Ringo'];
beatles.forEach(beatle => print(beatle));
```

---

external 和 internal 本质上的区别，在于流程的控制权（作者说的是 callstack）。
这部分差异，决定了两者擅长处理和不擅长处理的场景。


在 external iterator 里，消费者决定了遍历的时机。
可以轻易地中途终止遍历等。
但是，在处理复杂数据源，比如整合多个数据进行遍历的时候，生产者的逻辑就比较复杂了。


在 internal iterator 里，生产者决定了遍历的时机。
在遍历全部数据的场景中感觉更方便。
但是，如果要中途停止遍历，就需要 continuation 之类的机制来帮忙了。
