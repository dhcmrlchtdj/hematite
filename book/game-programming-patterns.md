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


