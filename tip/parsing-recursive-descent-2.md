# recursive descent

---

http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm
http://eli.thegreenplace.net/2012/08/02/parsing-expressions-by-precedence-climbing
http://www.oilshell.org/blog/2016/11/01.html

---

上次看这个文章，都已经一年多了。
至今没能完全掌握……

---

- 介绍的几个方法，都属于 recursive descent
- 是 parser，处理的是 token

- classic recursive descent
	- 每个调用都对应一个语法定义
	- left-associative 的操作符，我们在循环里处理，一点点读取
	- right-associative 的操作符，我们在递归里处理，提高右边的优先级

- shunting yard algorithm
	- 两个栈，一个 operator，一个 operand
	- 遇到 operand，直接丢到栈里
	- 遇到 operator，和栈尾比较优先级
		- 如果待处理的 operator 优先级高。直接入栈
		- 如果待处理的 operator 优先级低。
			- 高优先级 operator 出栈并处理 operand，结果入 operand 栈
			- 待处理 operator 入栈

- precedence climbing
	- 所有 binary operator 都设定一个优先级
	- 每个 operator 都会使用同一个函数 `getOperand` 来获得自己的 operand.right
		区别只在调用函数时传入的优先级
	- 过程
		- 假设一开始已经读取了一个优先级 -1 的 operator.1
		- 尝试获取 `getOperand(0)`，即要求下一个 operator 优先级更高
		- 读取 operand.1 和 operator.2
		- 如果 operator.2 的优先级小于 1，即不满足要求，那么直接返回 operand.1
			- 这种感觉 ((operand.1, operator.1, operand.2), operator.2, ...)
		- 如果 operator.2 的优先级大于等于了，那么使用 `getOperand(1)` 去获取新的 operand
			- 这种感觉 (operand.1, operator.1, (operand.2, operator.2, ...))
	- 要点
		- 开始假设一个最低优先级的 operator，保证之后的 getOperand 会读取全部输入
		- `getOperand` 本身是个循环，把所有相同优先级的都慢慢吃掉
		- 在增加右边优先级的时候，根据 operator.2 的结合性来判断
			- right-associative，直接使用相同优先级就行。因为函数调用本身暗含了优先级
			- left-associative，优先级要增加，保证遇到相同优先级的时候 operand 能返回
		- 如果碰到括号这种东西，直接重新从最低优先级开始，搞出一个 operand 来

---

- shunting yard / precedence climbing / top-down operator precedence
	三者其实是相同算法的不同表达
