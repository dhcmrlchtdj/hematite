# node error stack

---

# http://www.nearform.com/nodecrunch/node-js-develop-debugging-techniques/

---

可以在代码里

```js
Error.stackTraceLimit = Infinity;
```

或者在运行时

```
$ node --stack_trace_limit=1000 app.js
```
