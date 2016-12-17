# SICP

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

---

