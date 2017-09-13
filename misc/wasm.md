# WebAssembly

---

https://developer.mozilla.org/en-US/docs/WebAssembly
https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format

---

- `WebAssembly.Module` 是 stateless, compiled, like an ES2015 module
    - `WebAssembly.compile` 把 WASM binary 编译成 Module
- `WebAssembly.Instance` 是 stateful instance of Module
    - `WebAssembly.instantiate` 用 Module 或 WASM binary 生成 Instance
- `WebAssembly.Memory` 是 resizable ArrayBuffer
    - 单位是 page，1page=64kib
- `WebAssembly.Table` 是 resizable typed array of references
    - 不能存储成 raw bytes 的对象放到 table 中
    - 不过目前还只能存储函数

---

- web platform = a virtual machine + a set of Web APIs
    - the virtual machine will load and run two types of code - JS and WASM
- JavaScript has complete control over how WebAssembly code is downloaded, compiled and run
- JavaScript developers could even think of WebAssembly as just a JavaScript feature for efficiently generating high-performance functions

- WebAssembly cannot currently directly access the DOM
    - it can only call JavaScript, passing in integer and floating point primitive data types
    - to access any Web API, WebAssembly needs to call out to JavaScript, which then makes the Web API call

---

- WASM text format (.wat) 和 WASM binary format (.wasm) 是 1:1 对应的
- wat 用的是 S-exp
