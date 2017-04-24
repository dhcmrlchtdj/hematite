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

