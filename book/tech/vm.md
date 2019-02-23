# compiler design virtual machines

---

## imperative

- concepts
    - variable
    - expression
    - control flow
    - function
- architecture
    - stack memory, register SP (stack pointer), 0->max
    - instruction, register PC (program counter)
        - 读取指令，操作内存。PC 指向 instruction，SP 指向 memory。
        - stack + heap + BSS + DATA + TEXT(inst)
        - register IR (instruction register)
            - `while (true) { IR = instruction[PC]; PC++; execute(IR); }`
    - heap memory, register HP (heap pointer), max->0
        - SP 和 HP 相交，说明内存不够了。
        - 书里额外引入了 EP (extreme pointer)
            - EP 是函数调用需要的栈空间，可以在调用时就避免出现内存不足。
    - stack frame, register FP (frame pointer)
        - FP 指向 stack frame 开始的地方
- instruction
    - expression
        - right value (content), load
        - left value (address), store
    - statement
        - pop
    - control flow
        - jump
    - function
        - call
        - return
- memory allocation
    - variable
    - array / structure
    - heap
    - GC (we ignore releases of memory)
- function
    - stack frame
        - `function g() { f(x) }`
        - `stack f` point to `stack g`，被调用函数要能返回上层函数
        - 调用新函数时，之前的 PC/FP 要存储起来，回来时重新回到之前的 PC/FP
            - g 的 PC 是 f 的 return address
        - 其他变量的位置，都是以和 FP 的偏移量计算的
    - function call `fn G() { F(x) }`
        - `G_fp[main_pc,main_fp,G_ret_val,..,var_F,var_x],F_fp[G_pc,G_fp,F_ret_val,F_arg(x),...]`

---

## object-oriented
- compose
    - modularization
    - resuability of modules
    - extensibility of modules
    - abstraction
- concepts
    - extension of imperative
    - object (attribute + method)
    - class
    - inheritance
    - generic
- implement
    - register COP (current object pointer)

---

## functional

