# node stream

---

## links

---

### specification

+ https://iojs.org/api/stream.html
+ https://github.com/whatwg/streams
+ http://www.w3.org/TR/streams-api/

---

### article

+ https://github.com/substack/stream-handbook
+ https://github.com/substack/stream-adventure
+ http://brycebaril.github.io/streams2-presentation/
+ http://r.va.gg/2014/06/why-i-dont-use-nodes-core-stream-module.html
+ http://strongloop.com/strongblog/whats-new-io-js-beta-streams3/
+ http://stackoverflow.com/questions/21538812/what-is-streams3-in-node-js-and-how-does-it-differ-from-streams2
+ https://dl.dropboxusercontent.com/u/3685/presentations/streams2/streams2-ko.pdf

---

### package

+ https://www.npmjs.com/package/readable-stream
+ https://www.npmjs.com/package/concat-stream
+ https://www.npmjs.com/package/through2

---

## usage

---

### readable stream

+ 基本都是处理其他模块生产的 stream

```js
var Readable = require("readable-stream").Readable;
var rs = new Readable();
rs.push("example");
rs.push(null);
rs.pipe(process.stdout);
```

---

### writable stream

+ `concat-stream`

```js
var concat = require("concat-stream");
var write = concat(function(data) {
    console.log(data.toString());
});
process.stdin.pipe(write);
```

---

### transform stream

+ `through2`

```js
var through2 = require("through2");
var tr = through2(function(data, enc, cb) {
    console.log("doing");
    cb(null, data);
}, function(cb) {
    console.log("done");
    cb();
});
process.stdin.pipe(tr).pipe(process.stdout);
```

---

### stream 1/2/3

+ 分不清。
+ stream1 存在许多问题，直接用 stream2，不要使用 `data` 事件。

---

## example

---

### http proxy

```js
var request = require("request");
req.pipe(request(url)).pipe(res);
```

`pipe` 的时候，只传递了 `http body`，但 `request` 却能正确传递 `http status`。

测试了半天，发现是 `request` 重新实现了 `pipe` 方法。
<https://github.com/request/request/blob/master/request.js#L1245>。
这个绝对是大坑啊。
