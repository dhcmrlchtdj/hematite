# SICP

---

## 3.5

- 用 streams 这种数据结构，来模拟状态
	- 把时间 t 视为离散的数据，然后用函数 x(t) 来模拟状态

- 对比直接循环和使用高阶函数两种方式处理列表
	- 高阶函数更清晰，但会造成更大的时间、空间开销
	- 开销主要来自中间过程
	- streams 能做到兼顾高效和清晰

- delay 要求不直接对参数进行求值，所以应该理解成特殊语法的一部分
	- 延迟求值和并行计算存在矛盾这种说法到底对不对呢……
	- 普通的 delay 就是 call-by-name，加了缓存的 delay 就是 call-by-need

- 感觉就像迭代和循环的关系。
	在 stream 里面，变量变成了生成下一个值的参数，借此达成了消除局部变量的目的。

---

## 4

- 关于如何控制设计的复杂度
	- 前面三章讲了一些通用技术
	- combine primitive elements to form compound objects
	- abstract compound objects to form higher-level building blocks
	- preserve modularity by adopting appropriate large-scale views of system structure

- 为什么不要局限于某一种语言
	- 为特定场景设计的语言，能在特定场景下更高效的表达我们的想法
	- 为特定场景设计语言，能降低特定场景下问题的复杂度
	- 促使我们从不同的角度去思考问题
	- 不仅仅是计算机，所有工程设计的领域，都有 metalinguistic abstraction

---

## 4.1

- metacircular evaluator 的构成
	- eval
		- evaluate a combination (a compound expression other than a special form)
		- 计算出所有子表达式的值，然后 apply operator to operands
		- eval takes (expression, environment)
	- apply
		- apply a compound procedure to a set of arguments
		- apply 的对象是函数
		- 利用参数构建一个新的环境，然后在这个环境里执行函数体（evaluate）
		- apply takes (procedure, [arguments])

整个过程分成几步
- 把复合语句改写成基本语句，比如 `cond` 改写成 `if`
- 对于基本语句，按照语义执行，比如 `if`，就先计算条件的值，再看跳转到哪个分支
- 自定义的函数，其实就是在执行一系列语句，绑定好作用域就好
- 到最后内容都会转换到原生的调用，比如数字、字符、函数调用

- 关于 definition 和 assignment
	- 声明提前，然后未赋值前使用报错的做法，现在的 JS/PY 里都有吧
	- 没有太明白后面为何要这么做，避免引用到外层的变量吗
		- mutual recursion requires the simultaneous scope rule for internal procedure definitions
		- it is unreasonable to treat procedure names differently from other names
		- the definitions should be regarded as simultaneous
		- internal definitions look sequential but are actually simultaneous

- 效率
	- eval 效率比较低，因为需要重复解析文本
	- 把 (eval expression environment) 拆成 analyze 和 execution
		- ((analyze expression) environment)
		- (analyze expression) 返回 execution
		- 每次切换 environment 即可
	- 需要根据 env 确定的部分，都返回一个 (lambda (env) ...)，具体逻辑放到了 lambda 里面

本章的习题里，出现了停机问题，不动点组合子等

---

## 4.2

- applicative-order，参数先被求值，然后传递给函数
- normal-order，函数先执行，直到使用时才对参数进行求值

- lazy，直到使用参数时才对参数进行求值
	- normal-order 是语义层面的描述
	- lazy 是解释器层面的描述

- strict in argument，参数先求值，再调用函数
- non-strict in argument，先执行函数，必要时才对参数求值
	- strict / non-strict 是对某个函数的描述
	- applicative-order / normal-order 是对语言的描述
	- 通常 applicative-order 的语言，所有调用都是 strict 的
		而 normal-order 语言的复合语句都是 non-strict 的，基础语句则 strict / non-strict 都有可能

- thunk，需要计算的过程包裹成函数
- forcing，对 thunk 求值
- memoize，记录 thunk 求值的结果
- call-by-need，即 lazy 加上 memoize

- 需要注意 lazy evaluation 和 side effect 之间的相互影响

