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

### Command

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

### Flyweight

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

### Observer

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

### Prototype

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

---

### Singleton

---

> Ensure a class has one instance, and provide a global point of access to it.

GoF 里的定义。从 and 分开，总共说了两点。
使用单例的场景，有时候是因为要某些共享变量，有时候是因为无法创建实例。

---

单例带来的问题有

- 全局变量
    - 不易排查问题
    - 造成代码耦合
    - 不易并发
- 即使只遇到一个问题，这模式本身解决的是两个问题
- 执行时才初始化，意味着额外的开销

---

单例的使用场景之一，是为了能更容易地接触到实例。
替代的方案有

- 将实例作为参数传递
- 实例放在基类中实现共享
- 实例放在现有的全局变量下
- 从 ServiceKicator 获取实例

---

### State

---

场景：
用户输入按键后，角色起跳。
为了避免出现在空中起跳的情况，需要在起跳前检查角色当前的状态。
然后要支持躲避的功能。
为了避免空中躲避等情况，起跳前要检查是否在躲避，躲避前要检查是否已起跳。
然后要支持攻击功能。
攻击与起跳、躲避是相斥的，也需要做判断。
要判断的状态越来越多，if 语句各种嵌套。
代码难读难改……

---

可以用状态机来解决这种问题。
用户在某些状态下，可以执行某些操作，随后进入另一种状态。

---

```javascript
const STATE = {
    STARTING: 1,
    JUMPING: 2,
    DUCKING: 3,
    DIVING: 4,
};

let state = STATE.STARTING;
let chargeTime = 0;
const handleInput = (input) => {
    switch (state) {
        case STATE.STARTING:
            if (input === 'PRESS_B') {
                state = STATE.JUMPING;
            } else if (input === 'PRESS_DOWN') {
                state = STATE.DUCKING;
                chargeTime = 0;
            }
            break;
        case STATE.JUMPING:
            if (input === 'PRESS_DOWN') {
                state = STATE.DUCKING;
            }
            break;
        case STATE.DUCKING:
            if (input === 'PRESS_DOWN') {
                state = STATE.STARTING;
            }
            break;
    }
};
```

简单的例子，能够看些基本信息。
主要状态都交给了状态机来维护。
可能还是要手工维护一些状态，比如上面的 chargeTime。

---

上面只是 FSM，如果把状态变化放到一个栈里，就有了一个下推自动机。

---

## Sequencing Patterns

---

### Double Buffer

---

- read from *current* buffer
- write to *next* buffer
- *swap* current and next

模式本身不复杂，读写分离，也算是预处理？

---

> This pattern is one of those ones where you’ll know when you need it.

主要还是用在状态需要频繁变化的场景。

---

buffer 意味着需要额外的内存，swap 意味着需要额外的时间。
要注意使用场景是否允许这些额外负担。

---

- swap 可以靠交换指针来实现，这就要求外部不能直接保存指针的值。
    - 写入数据时，注意是否依赖当前展示中的 buffer 的状态
    - 当前写入的 buffer 不是当前展示中的 buffer
- 如果不用指针实现，每次都要完整复制整个 buffer
    - 写入可以不考虑影响
    - 交换的时间更长，毕竟比修改指针引用要复杂

---

### Game Loop

---

```javascript
while (true) {
    processInput();
    update();
    render();
}
```

这样一个主循环里，循环速度是运行环境决定的。
我们需要一个自己的时序控制。

---

> it runs the game at a consistent speed despite differences in the underlying
> hardware.

本章的模式要做的就是这么一件事情，控制循环的速率。

---

插入一个作者对 engine 和 library 的理解

- you own the main game loop and call into the library
- engine owns the loop and calls into your code

看循环控制在谁的手里。

---

在比较快的机器上，可以通过等待让游戏进程减速

```javascript
const FPS = 60;
const MS_PER_FRAME = 1000 / FPS;
while (true) {
    const start = Date.now();

    processInput();
    update();
    render();

    sleep(start + MS_PER_FRAME - Date.now());
}
```

但是这对较慢的机器就没有效果了。

---

可以将速度的控制下放给程序。

```javascript
let lastTime = Date.now();
while (true) {
    const current = Date.now();
    const elapsed = current - lastTime;

    processInput();
    update(elapsed);
    render();

    lastTime = current;
}
```

在上面的例子里，能够知道距离上一帧过了多长时间。
可以根据这个时间来更新状态。
比如游戏里人物移动了多长的距离，机器快则更新频率高但移动距离短，机器慢则更新频率低但移动距离长。

看似完美，但是还是有不足。
比如机器速度相差较大的两人联机，用户输入频率的差异就会凸显出来。

---

另一个思路是将状态更新和渲染分开。

```javascript
let previous = Date.now();
let lag = 0;
while (true) {
    const current = Date.now();
    const elapsed = current - lastTime;
    previous = current;
    lag += elapsed;

    processInput();

    while (lag >= MS_PER_UPDATE) {
        update();
        lag -= MS_PER_UPDATE;
    }

    render();
}
```

上面这个修改版里，不立刻渲染，而是只更新状态。
注意 `lag` 在循环中是不会被重置，而是累计的。
在比较快的机器上，lag 没达到 `MS_PER_UPDATE`，所以不会更新状态。
在比较慢的机器上，lag 在没追回之前，每次都会更新状态。
这个 `MS_PER_UPDATE` 的取值要小心一些，至少不能比 `update()` 需要的时间短吧……

- `update` 的执行间隔，是代码控制的。
- `render` 的执行间隔，是机器速度决定的。

也不是没有问题，肯定会有渲染和更新不同步的时候。
不过不部分情况下，这种差异都能忽略。

---

### Update Method

---

前面 game loop 的例子里有个 `update()`。
这里说的是如何组织 update 里面的代码。

---

具体来说，就是为每个需要更新的实体实现一个 `update` 方法，然后调用。

有些简单的场景，其实不值得为每个实体维护一个方法，毕竟不是每次循环都需要更新。
比较适合大量实体同步更新的场景，这些实体之间有相对独立。

---

虽然看着简单，还是有需要考虑的地方。

- 代码拆分，关系变得复杂。
- 拆分后，需要独立维护状态。
- 虽然都是在 render 之前执行的，但是还是有先后关系。注意先后是否影响状态变化。
- 有很多对象在等待更新，会不会出现待更新的对象被前面的操作删除的情况。

---

## Behavioral Patterns

---

### Bytecode

---

如果逻辑都是硬编码的，意味着修改一部分逻辑也需要将程序全部重新打包。
对于一些需要更大灵活性的场景，使用一个沙箱来动态执行一些操作会更适合。

适合需要动态定义大量操作，但是底层的实现语言又不具备这种的能力的时候。
要考虑到动态解释的开销，执行起来会比原生代码要慢。

---

- an instruction set
- a series of instructions -> a sequence of bytes
- a virtual machine
- a stack for intermediate values

---

```javascript
class VM {
    push(value) { this.stack.push(value); }
    pop() { this.stack.pop();

    interpret(bytecodeList) {
        this.stack = [];

        let literal = false;
        for (const instruction of bytecodeList) {
            if (literal) {
                literal = false;
                this.push(instruction);
                continue;
            }

            switch (instruction) {
                case INST_A: do(); break;
                case INST_B: do(); break;
                case INST_C: do(); break;
                case INST_D: do(); break;
                case INST_ADD:
                    const x = this.pop();
                    const y = this.pop();
                    const sum = x + y;
                    do(sum);
                    break;
                case INST_LITERAL:
                    literal = true;
                    break;
            }
        }
    }
}
```

demo 里面，基础的指令匹配和栈的使用也都有了。

---

VM 大致有 stack-based 和 register-based 两种

stack-based 的

- 指令更简单（通常就 1byte）
- 代码生成器更简单
- 指令集更大

总是操作栈顶的数据，所以指令本身不复杂，转换成代码逻辑也更简单。
但是为了完成复杂的操作，需要的指令类型就更多了。

register-based 的

- 指令更复杂（比如 lua 的有 32bit）
- 指令集更小

不只是操作栈顶，而是同时操作多个寄存器，所以指令更复杂。
但相对的，完成不同工作需要的指令集就小了。

---

如何在 VM 中表示数据

- single datatype。只提供一直类型的数据。很简单，不会出错。相对的连数字、字符串都分不开。
- tagged variant。每种类型都带上标记。花费一点额外的空间。
- untagged union。只是一堆字节，靠生成数据前约定好数据类型。
- interface。更面向对象的方式，每个数据对象字节提供各种方法来判断、转换。复杂低效。

---

### Subclass Sandbox

---

- baseclass 拥有所有行为
- subclass 选取其中某些行为

---

```javascript
class SuperPower {
    powerA() { ... }
    powerB() { ... }
    powerC() { ... }
}
class HeroA extends SuperPower {
    activate() {
        this.powerA();
        this.powerB();
    }
}
class HeroB extends SuperPower {
    activate() {
        this.powerB();
        this.powerC();
    }
}
```

---

如果把操作都这样封装起来，subclass 和外界的耦合就减少了很多。
和外界交互的都是 baseclass。

关键是如何判断把方法放在 baseclass 还是 subclass。

---

### Type Object

---

- 实例之间有相同的属性名，但每个创建一个子类又比较浪费。
- 将这些变化的属性拿出来，单独包装成一个类。
- 不同类型的实例，用不同的参数去初始化这个属性对象。
- 不同实例是实例化同一个类，区别只在于其中的属性对象的值不同。

---

如何实例化这样的实例？
- 可以先创建实例，再赋一个 type object。
- 可以由不同的 type object 来实创建新实例。

---

创建之后，外部是否知道 type object 的存在，type object 能否动态修改，都要考虑。

---

感觉类似与 mixin 之类的吧。
作者也反对使用多继承。

---

## Decoupling Patterns

---

### Component

---

