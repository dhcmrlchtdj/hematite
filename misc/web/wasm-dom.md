# wasm 为什么不支持 dom api

WASM 不能直接调用 DOM API。

比如在 rust 里需要引入 [web_sys](https://rustwasm.github.io/wasm-bindgen/api/web_sys/)。
以 [without-a-bundler](https://github.com/rustwasm/wasm-bindgen/tree/0.2.43/examples/without-a-bundler) 为例，生成的 JS 里对 `createElement` 这些 API 做了封装。

```javascript
function __widl_f_create_element_Document(arg0, arg1, arg2, exnptr) {
    let varg1 = getStringFromWasm(arg1, arg2);
    try {
        return addHeapObject(getObject(arg0).createElement(varg1));
    } catch (e) {
        handleError(exnptr, e);
    }
}
const imports = { './dom': __exports }
WebAssembly.instantiate(module, imports)
```

其他语言的情况也类似。

那么，为什么浏览器不直接提供 DOM API 呢？
有大神给出了 [解释](https://github.com/WebAssembly/design/issues/1184#issuecomment-378336653)。
传递给 WASM 的 DOM 对象，要能正确地被宿主回收，这就需要和宿主的 GC 进行交互。

## GC
本来想写点 GC 的，但是发现 GC proposal 下面没什么 GC 实现相关的内容。

## 异常处理
另外一个相关的是异常处理，结果 proposal 看得也是云里雾里……

- WASM 不知道宿主使用哪种异常机制
- WASM 无法直接操作宿主的内存
- 异常涉及到引用、内存处理
