# ReactiveX / rxjs

---

https://github.com/ReactiveX/rxjs/tree/6.2.0/doc

---

- observable
- observer
- subscription
- subject
- scheduler
- operators

最近心血来潮又想看下 rxjs
先把概念重新过一遍
找时间看下代码（rxjs 里代码简直有点凌乱

---

## operators

operators 就是 `map / filter` 等操作，算是最容易理解的概念了。

---

## scheduler

rxjs 里，observable 在 subscribe 之后执行。
scheduler 决定了执行的时机。

- `null` 默认使用 `???`
- `Rx.Scheduler.async` 使用 `setInterval(...)`
- `Rx.Scheduler.asap` 使用 `Promise.resolve().then(...)`
- `Rx.Scheduler.animationFrame` 使用 `requestAnimationFrame(...)`
- `Rx.Scheduler.queue` 使用 `???`

这块等看代码

---

## observer

类型应该是最能说明问题的

```typescript
interface Observer<T> {
    closed?: boolean;
    next: (value: T) => void;
    error: (err: any) => void;
    complete: () => void;
}
```

使用时就 `observable.subscribe(observer)`

---

## subscription

```typescript
interface Unsubscribable {
    unsubscribe(): void;
}

const subscription = observable.subscribe(observer);
subscription.unsubscribe();
```

subscribe 之后再取消

---

## observable

rx 涉及的主要概念在这部分

---

首先是 pull 和 push 的区别

- pull
    - producer is passive
    - consumer is active
    - consumer decides when data is requested
- push
    - producer is active
    - consumer is passive
    - consumer reacts to received data

为了直观理解，可以假设 producer 是一个数组，consumer 是一个函数。

用一个 for-loop 读取 producer 的值，交给 consumer 处理，这是 pull 模式。
for-loop 可以算是 consumer 的一部分，整个过程 consumer 占据主动，可以随时终端读取。

用 map 等高阶函数读取 producer 的值，属于 push 模式。
consumer 被动地等待被调用，用什么方式传递数据是 producer 决定的。

---

然后是 pull/push 与 single/multiple 的结合

- pull + single = function
- pull + multiple = iterator
- push + single = promise
- push + multiple = observable

---

最后是 observable 的四种操作

- create
- subscribe
- execute
- dispose

---

## subject

subject 既是 observable 又是 observer。
是数据的二道贩子

一般情况下，多个 observer 进行 subscribe 会导致 observable 执行多次。
subject 就是为了处理这种场景，让多个 observer 共享一次的执行结果。
