# timer

---

https://nodejs.org/en/docs/guides/timers-in-node/
https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/

---

以前都在看 WebAPI，对 node 关注度不够。
今天看了就简单写写。

---

```
   ┌───────────────────────┐
┌─>│        timers         │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
│  │     I/O callbacks     │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
│  │     idle, prepare     │
│  └──────────┬────────────┘      ┌───────────────┐
│  ┌──────────┴────────────┐      │   incoming:   │
│  │         poll          │<─────┤  connections, │
│  └──────────┬────────────┘      │   data, etc.  │
│  ┌──────────┴────────────┐      └───────────────┘
│  │        check          │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
└──┤    close callbacks    │
   └───────────────────────┘
```

虽然 webapi 里的 event loop 也没那么简单，但是只用 macrotask 和 microtask 也能基本理解。
node 里这个，看着就更复杂些。

> When the queue has been exhausted or the callback limit is reached,
> the event loop will move to the next phase.

通常来说，进入某个阶段，就会把这个阶段里的待执行函数全部跑完。
不过这里提到，对回调的数量是有限制的。
如果回调数量太多，会出现没执行完就进入下一阶段的情况。

---

- `setTimeout / setInterval` 都属于 `timers`
- `setImmediate` 属于 `check`，即 IO 之后，timers 之前
- `socket.on('close', ...)` 属于 `close callbacks`
- 其他代码逻辑的回调基本都属于 `I/O callbacks`

---

> setImmediate() will always be executed before any timers if scheduled within
> an I/O cycle, independently of how many timers are present.

> setImmediate() fires on the following iteration or 'tick' of the event loop.

- 没有 IO 的话，setTimeout 和 setImmediate 执行的先后顺序是不确定的
- 有 IO 的话，setImmediate 会先执行

---

> process.nextTick() is not technically part of the event loop.
> the nextTickQueue will be processed after the current operation completes,
> regardless of the current phase of the event loop.

> process.nextTick() fires immediately on the same phase.

- nextTick 属于 microtask，不在大的 loop 里
