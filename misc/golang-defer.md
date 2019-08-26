## go defer

http://www.zenlife.tk/golang-defer.md

> defer是在return之前执行的
> 整个return过程，先在栈中写一个值，这个值会被当作返回值，然后再调用RET指令返回
> return xxx语句并不是一条原子指令，defer被插入到了赋值与RET之前，因此可能有机会改变最终的返回值
> `tmp_ret = xxx; defer(); return tmp_ret`

上文给的例子里，最怪异的是这个返回 5

```golang
func f() (ret int) {
	t := 5
	defer func() { t = t + 5 }()
	return t
}
```

执行 `return t` 的时候，先执行了 `ret=t`。
之后对 t 的修改，并不影响 `ret` 的结果。

相应的，如果修改了 `ret`，返回值就会变成 10

```golang
func f() (ret int) {
	t := 5
	defer func() { ret = ret + 5 }()
	return t
}
```
