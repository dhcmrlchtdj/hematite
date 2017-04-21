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


