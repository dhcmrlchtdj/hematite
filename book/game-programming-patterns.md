# Game Programming Patterns

---

http://gameprogrammingpatterns.com/

---

- make code cleaner, easier to understand, and faster

---

## Introduction

---

### Architecture, Performance, and Games

---

- architecture is about change
    - 修改是前提
    - 如果不需要再修改，那什么架构都无所谓了
- coupled
    - 什么叫做耦合
    - you can’t understand one without understanding the other
- decoupling
    - 解耦有什么用处
    - a change to one piece of code doesn’t necessitate a change to another
- minimize the amount of knowledge you need to have in-cranium before you can make progress
    - 作者将这视为软件架构的核心目标之一
    - 通过解耦实现代码隔离

---

- 未来难以预测，所以哪些地方需要进行抽象、解耦也很难判断
    - （这也就是经验丰富的程序员的价值吧
- 过度抽象，非但没有达到解耦的目的，反而需要在改动前熟悉更多的抽象层

---

- performance is all about assumptions
    - 架构让程序更灵活，灵活意味着更少的假设，减少限制
    - 性能是靠各种限制换来的

---

## Design Patterns Revisited

---

### command

---

> Commands are an object-oriented replacement for callbacks.

---

现在有这样的代码。
读取用户输入，然后调用相应的处理。

```javascript
const handleInput() {
    if (isPressed(BUTTON_X)) jump();
    else if (isPressed(BUTTON_Y)) fireGun();
    else if (isPressed(BUTTON_A)) swapWeapon();
    else if (isPressed(BUTTON_B)) lurchIneffectively();
}
```

可以看出，新增操作要改代码，更换按键对应的操作也要改代码。

---

可以将按键对应的操作抽离。
这样每个用户输入都有一个对应的可执行函数。

```javascript
class Command { execute() {} }
class X extends Command { execute() { jump(); } }
const handleInput() {
    if (isPressed(BUTTON_X)) return buttonX_;
    if (isPressed(BUTTON_Y)) return buttonY_;
    if (isPressed(BUTTON_A)) return buttonA_;
    if (isPressed(BUTTON_B)) return buttonB_;
    return null;
}
comm = handleInput();
if (comm) comm.execute();
```

需要新增按键操作，在这个分发出增加即可。
要修改按键对应的操作，在按键自己的实现里去修改。

同时，上面的代码里，用户输入只判断输入了什么，对应哪个操作。
具体什么时候执行操作，控制权交了出来。
这时候可以继续增加是否执行操作的判断、增加一些额外参数等。

---

在一些可以撤销、回退的场景中，也可以用到这个模式。

```javascript
class Command {
    execute() {}
    undo() {}
}
```

不过，undo 涉及到更多的状态处理，可能还需要在操作时记录当前的变化量。

通过维护多个操作队列，就可以实现 undo/redo 等行为。

另外一种实现 undo/redo 的方式是使用持久化的数据结构（persistent data structure）。

---

### flyweight

---

页面渲染大量相同的元素（文中的例子是渲染大量的树），造成两个问题。
其一，内存占用大；其二，渲染工作量大。

将元素的公共部分抽离出来共用，可以达到减少内存使用的目的。
渲染则分成三步完成，先传送通用部分，再传送大量的独立部分，最后一次性渲染。

这个模式做的主要工作，就是将公共部分拿出来共用，使得个性化的数据变得轻量。

---

（插入一些题外话
组织代码的两种方式
一种是按对象分组，一个对象的所有操作放在一起。
另一种是按操作分组，针对不同对象的实现都放在一起。

---

你有大量枚举类型的数据，然后在代码里用 `switch...case` 来判断应该执行什么操作。
这时就可以考虑使用 flyweight 来增强代码的可维护性。

---

用代码说明的话

```javascript
const world = [ ['A', 'B', 'C'], ['A', 'A', 'A'], ... ];
const getCost = function(world, x, y) {
    switch (world[x][y]) {
        case 'A': return 1;
        case 'B': return 2;
        case 'C': return 3;
        default: return 4;
    }
};
```

开始是这样，由于数据量很大，所以选择用枚举而不是大量的实例

```javascript
const A_ = {cost: 1};
const world = [ [A_, B_, C_], [A_, A_, A_] ]
const getCost = function(world, x, y) {
    return world[x][y].cost;
};
```

然后改成这样，虽然生成的实例，但其实都在共用同一个。
就这样将分发逻辑与实现逻辑分开了。

---

### observer

---

> But in architecture, we’re most often trying to make systems better, not perfect.

先摘这么一句，说的是发布消息的时候。
代码还是要知道自己要发送什么格式的消息，代码还是要知道向哪里发送消息。
耦合还是存在的。
但是，架构要做的，是让代码比之前更好，即使最后方案还不够完美。

---

脑袋里会冒出许多问题
- 广播的通道谁来提供？
- 发送消息时是否会阻塞？
- 发送的消息是否有序？
- 还没被接收的消息是否会被缓存？

---

```javascript
class Subject {
    constructor() {
        this.obs = [];
    }
    notify(msg) {
        this.obs.forEach(i => i.onNotify(msg));
    }
    addObserver(ob) {
        this.obs.push(ob);
    }
    removeObserver(ob) {}
}
class Observer {
    onNotify(msg) {}
}
```

这个框架实现的比较简单。
要注意一点是，这里的 notify 是同步操作，所以 onNotify 执行时间过长的话，对整个系统影响都很大。
确实需要执行长时间任务时，可能需要多线程、加锁等操作。也许异步的消息机制会更适合。

---

> It’s a tenet of good observer discipline that two observers observing the
> same subject should have no ordering dependencies relative to each other.

还是前面的问题，两个接受者不该对顺序有依赖，两个消息呢？
在前面的代码里，都是同步执行，所以发出去的两个消息肯定是有序的。

---

> It’s an observer’s job to unregister itself from any subjects when it gets
> deleted.

subject 里是持有 observer 引用的，所以如何删除对象就成了问题。
最简单的就是 observer 要销毁时把自己从 subject 里删除。

---

observer 模式是个单向的消息传递。
如果两个模块间的通信是单向的，可以考虑 observer；
如果通信是双向的，其他模式可能更适合。

---

> ..., but it’s dead simple and it works.
> To me, those are often the two most important criteria for a solution.

本章的结束语，简单、可行，这才是最重要的。

---

### prototype

---

prototype 作为设计模式来说，并没有什么非他不可的使用场景。
在类型可以作为参数的传递的语言中，实现起来也可以非常灵活。
它的另一个意义在于作为一种语言的范式（language paradigm）。

---

> OOP lets you define “objects” which bundle data and code together.
> OOP marry state and behavior

- class 的语言，instance 持有 field，然后去 class 里寻找 method
- prototype 的语言，object 同时持有 field 和 method，然后去 parent 找缺失的 method/field

---

> missing the structure that classes give

作者认为 prototype 更适合作为库存在，不适合作为语言层面的机制。
将 class 用于数据划分，更符合思维（至少是作者自己的）。

---

> JavaScript in practice has more in common with class-based languages than
> with prototypal ones.
> JavaScript has taken steps away from Self is that the core operation in a
> prototype-based language, cloning, is nowhere to be seen.

作者认为 JS 在使用上，其实是很接近 class 的。
prototype 最核心的是 clone 操作，而 JS 并没有这种操作。
prototype 实现继承，是直接 clone 一个 object 来生成新的 object。
而 JS 的继承是有构造函数的。

---

> The reason we use programming languages is because they have tools for
> managing complexity.

SICP 里也有类似的描述。
不同编程语言针对不同场景，做一些特殊封装，能够减少问题的复杂度。

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Details_of_the_Object_Model

补充一下，MDN 里关于 class-based vs. prototype-based 的描述

- class-based 严格区分 class/instance；prototype-based 里全部都是 object
- class-based 在定义 class 时就确定了继承关系；prototype-based 可以动态设置原型链
