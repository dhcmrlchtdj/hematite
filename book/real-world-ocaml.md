# real world ocaml

---

## prologue

---

列举了一些 ocaml 的特点

- garbage collection
- first-class functions
- static type-checking
- parametric polymorphism
- immutable programming
- automatic type inference
- algebraic data types & pattern matching

如果只看到这些，感觉确实很棒啦

---

安装指南
https://github.com/realworldocaml/book/wiki/Installation-Instructions

---

## Variables and Functions

---

ocaml 默认有些奇怪
比如 `=` 可以比较整数和浮点型，但是 `+` 只能用于整数

---

可以自定义中缀表达式

```ocaml
let (|>) x f = f x ;;

let path = "/usr/bin:/usr/local/bin:/bin:/sbin";;
String.split ~on:':' path
    |> List.dedup ~compare:String.compare
    |> List.iter ~f:print_endline
;;
```

可以实现这种 pipe 的效果

---

函数定义方式
真的就是回字的四种写法了 🙄️

---

- ocaml 还是能拿到函数的引用的
    - 比如 `let now = Time.now ;;`
    - 调用的话，需要 `let n = Time.now ();;` 或者 `let n = now ();;`

---

## Files, Modules, and Programs

---

```
$ ls
freq.ml

$ ocamlfind ocamlc -linkpkg -thread -package core freq.ml -o freq.byte
$ ocamlfind ocamlc -custom -linkpkg -thread -package core freq.ml -o freq.native

$ ocamlfind ocamlopt -linkpkg -thread -package core freq.ml -o freq.native

$ corebuild freq.byte
$ corebuild freq.native
```

- ocamlc 是 bytecode compiler
    - 代码跑在虚拟机上
    - 像 OCaml debugger 之类的工具，只能用于 bytecode
    - 也可以把 runtime 一起打包
- ocamlopt 是 native-code compiler
    - 可以用 gdb 调试

---

```
$ corebuild counter.inferred.mli
$ cat cat _build/counter.inferred.mli
```

- `.mli` 是接口定义
- 通常会有接口定义、类型定义、文档等
- 虽然可以用工具生成，不过通常会选择手写来保证可读性

---

- 文件名即模块名
- 模块名总是大写首字母

比如 `counter.ml` 对应的模块就是 `Counter`

- 可以在文件内嵌套模块
- `module <name> : <signature> = <implementation>`

- `open <name>` 后可以直接使用模块内的函数、变量
    - 不这么做也可以通过引用模块名来使用模块内的函数、变量
    - 直接 `open` 等于是污染当前环境
    - 尽可能少进行 `open` 操作
    - 即使要做也尽可能把作用域限制在局部

- 模块里可以 `include <name>` 来扩展生产新模块

---

## Records

---

- record 的 field 名必须小写开头
- record 的 field 可以申明为可变的，`mutable`
    - 使用 `<-` 来赋值
- `var.field` 和 `var.RecordName.field` 两种写法都可能出现
    - field 名肯定是小写的，所以看到大写肯定是后一种写法
    - 明确表明是哪个  record

---

- ocaml 有很多不同的编译警告
    - 可以用这样的方式在文件里打开警告 `#warnings "+A";;`
    - 查看可选的警告，可以执行 `ocaml -warn-help`
    - 执行时设置 `ocaml -w @A-4-33-41-42-43-34-44 ...`

- 在自动推断 record 的类型时，会使用最近的那个

---


---

## Memory Representation of Values

---

- `Obj` 模块
- ocaml 在编译时严格检查类型，在执行时把大部分类型信息都抹去了。
- ocaml 没有 JIT，更多依赖静态分析
- 基础类型有数字和指针，靠最后一个 bit 来区分，1 是数字，0 是指针
- 数据都是 byte 对齐的，长度不够会加 padding
- 复杂数据包括 `size(22/54)/color(2)/tag(8)` 三个字段组成的头部
    - size 是具体数据的长度
    - color 用于垃圾回收
    - tag 用于表示具体的数据类型

---

## Garbage Collector

---

- `Gc` 模块
- `OCAMLRUNPARAM` 环境变量
- generational GC
    - generational hypothesis
        - young blocks tend to die young
        - old blocks tend to stay around for longer than young ones
    - small, fixed-size minor heap
    - larger, variable-size major heap
- minor heap
    - stops the world
    - copying collection
    - 空间用完就会触发 gc，然后将存活的对象移动到 major gc
    - 大部分对象都会先进入 minor heap，而较大的对象会直接进入 major heap，避免触发 gc
    - intergenerational pointers
    - write barrier
- major heap
    - stop the world
    - mark-and-sweep
    - 除了标记清除，还有个 compact 来减少内存碎片，不过没那么频繁
    - 标记清除时会对内存分片，分批执行，减少暂停时间
    - 压缩时对整个内存一起执行，暂停时间会更长一些
    - 分配内存默认使用 next-fit 策略，备用策略为 first-fit
    - 四色标记
- 析构？
    - 堆上的可变数据，可以在被 gc 的时候执行一些回调，finalization

---

## Compiler Frontend

---

```
    Source code
        |
        | parsing and preprocessing
        |
        | camlp4 syntax extensions
        |
        v
    Parsetree (untyped AST)
        |
        | type inference and checking
        v
    Typedtree (type-annotated AST)
        |
        | pattern-matching compilation
        | elimination of modules and classes
        |
        v
     Lambda
      /   \
     /     \ closure conversion, inlining, uncurrying,
    v       \  data representation strategy
 Bytecode    \
    |         +-----+
    |               |
    |              Cmm
    |ocamlrun       |
    |               | code generation
    |               | assembly & linking
    v               v
 Interpreted    Compiled
```

---


