# colorful function

---

http://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/
https://lukasa.co.uk/2016/07/The_Function_Colour_Myth/
https://glyph.twistedmatrix.com/2014/02/unyielding.html

---

- sync functions return values, async functions return `Future<T>`
- sync functions arejust called, async functions need `await`

async/await 其实没能解决异步的问题
在最基本的调用、组合上，和所有异步函数存在相同的问题

> red functions can only be called by red functions

---

- goroutines in Go
- coroutines in Lua
- fibers in Ruby

作者认为这些技术，真正解决了异步的问题。

> multiple independent callstacks that can be switched between.

---

- straight callbacks: callback
- "managed" callbacks: promise
- explicit coroutines: async/await
- implicit coroutines: gevent

第二篇文章作者指出，其实这三种风格都是可以用同步的方式实现的
可以不需要 event-loop

这里是种妥协，使用 async/await 可以使代码更清晰，但是可复用性降低了
