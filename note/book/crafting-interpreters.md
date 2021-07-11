# crafting interpreters

https://craftinginterpreters.com

---

感觉 clox 就是 wren/lua 的导读

---

- Chunks of Bytecode
    - dynamic array
- Scanning on Demand
    - parser 驱动 tokenizer
- Compiling Expressions
    - pratt parser
    - 优先级，左右结合性（实现时其实也是表现为优先级）
    - 先区分两种场景
        - prefix/closfix 即左边没有其它表达式
        - infix/postfix/mixfix 即左边有其它表达式
    - 再考虑当前操作符的优先级
- Hash Tables
    - `string interning` 全局只保存一个字符串
- Jumping Back and Forth
    - 使用 jump 构造 if/while
    - `backpatching`
        - 先 `emitJump` 预留 `offset` 空间
        - 再构造循环体的字节码
        - 之后 `patchJump` 修正 `offset` 即需要跳过多少字节码
    - 是否跳转，看 value stack；跳转多少，看 opcode stack
- Calls and Functions
    - 函数调用栈 call frame
    - 每个函数都编译成单独的 opcode stack，然后函数引用放到了 value stack 上
    - 调用函数，直接切换到函数的 opcode stack，执行完回到之前的 opcode stack stack
- Closures
    - 闭包的构成，包括被编译成字节码的函数以及函数执行时捕获的变量。一个是编译期的，一个是运行时的。
    - 普通变量还是在栈上。闭包捕获的变量会被加入 upvalue 数组。
    - 编译器在解析函数的时候
        - 遇到非 local 的变量，递归向上查找，加入 upvalue 数组，标记成要捕获的
            - 解释器从函数返回的时候，会清空 stack，这时将需要捕获的变量，转移到 heap 上
        - 加入 upvalue 的时候，要标记清楚，是来自上一层函数，还是更外层
            - 解释器构造函数的时候，需要自己捕获 upvalue，还是使用上一层函数捕获的 upvalue
    - 解释器在构造函数的时候
        - 区分 open upvalue 和 closed upvalue
            - 也就是，还在 stack 上的的变量，和已经被转移到 heap 的变量
        - 构造函数的时候，虽然捕获了，但还都是 open upvalue
    - 解释器在执行函数的时候
        - 从函数返回的时候，会清空 stack，这时将需要捕获的变量，转移到 heap 上
            - 此时 open upvalue 变成 closed upvalue
        - 维护一个 open upvalue 的链表
            - 捕获变量的时候，加入这个链表
            - 转移变量的时候，遍历链表，将 open upvalue 修正为 closed upvalue
- Garbage Collection
    - mark-sweep，不过对简单场景也够用了
        - 维护一个 worklist 保存 grey 的对象
    - 衡量 GC 算法好坏
        - Throughput, the total fraction of time spent running user code versus doing garbage collection work
            - eg. spend 90% of the time running the program and 10% on GC overhead
        - Latency, the longest continuous chunk of time where the user's program is completely paused while garbage collection happens
    - 频率
        - run frequently enough to minimize latency but infrequently enough to maintain decent throughput
        - the collector frequency automatically adjusts based on the live size of the heap
            - 动态调整 GC threshold
            - 书中用的方法，是将阈值设置为当前使用量的 2 倍 (the scaling factor is basically arbitrary
    - 优化
        - concurrent garbage collector
        - incremental garbage collector
- Classes, Instances, Methods, Initializers, Superclasses
    - class, instance, bound method, inheritance
        - copy-down inheritance, 直接把 method 复制了一遍
        - prototype/delegation vs class/inheritance
    - （全部转写成 closure 再编译算了
    - superinstruction, fusing several instructions into one
- Optimization
    - NaN boxing 和 pointer tagging
        - 在哪见过一个说法，48bit 足以存放内存空间，是个有风险的判断
    - 以前看 quickjs 的时候记录过
        - quickjs 在 32bit 时使用 NaN boxing
        - 但是在 64bit 下不用，作者觉得 tagged union 够了
        - 不论 32bit + NaN boxing 还是 64bit + tagged union，一次都是 2 word 的数据
