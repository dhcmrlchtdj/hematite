# pratt parsing

---

https://www.oilshell.org/blog/2017/03/31.html

---

发现作者又更新了几篇。

---

其实从 https://www.oilshell.org/blog/2017/03/30.html 的对比来看。
Precedence Climbing 会简单不少，一个优先级 table，一个递归函数。

---

https://www.engr.mun.ca/~theo/Misc/pratt_parsing.htm

---

```
S --> E0 end
E0 --> E10
E10 --> E20 | E20 "=" E20
E20 --> E30 | E20 "+" E30 | E20 "-" E30
E30 --> E40 | E30 "*" E40 | E30 "/" E40
E40 --> E50 | E40 "!"
E50 --> E60 | E60 "^" E50
E50 --> P
P --> "-" E30 | "(" E0 ")" | v

- a nonassociative binary operator "=" (e.g., "a=b=c" is not in the language of S),
- left-associative operators "+", and "-"
- a prefix operator "-"
- left-associative operators "*" and "/"
- a postfix operator "!"
- a right-associative operator "^".
```

这个还真是很清晰易懂，左右结合、优先级、前后缀都有了。

```
S is const t := E(0) ; expect( end ) ; output(t)

E(p) is
    precondition 0 ≤ p
    var t := P
    var r := +inf
    while p≤prec(next)≤r
        const b := next
        consume
        if isBinary(b) then
            const y := E( rightPrec(b) )
            t := mknode(binary(b), t, y)
        else t := mknode(postfix(b), t)
        r := nextPrec(b)
    return t

P is
    if next="-" then ( consume ; const t:= E(30) ; return mknode(prefix('-', t)) )
    else if next = "(" then ( consume ; const t := E(0) ; expect(")") ; return t )
    else if next is a v then ( const t :=  mkleaf(next) ; consume ;  return t )
    else error( "Unexpected token '" +next+ "'" )
```

伪代码也算清晰

---

关于三元操作符，还有函数调用之类的表达式，作者自己这么说的。

> these extentions are ad hoc and complicate the E and P procedures.
> To accomodate operators like these and additional prefix operators in a
> modular way, we can use Pratt parsing.

---

http://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/

---

写之前考虑清楚各种 operator
有各种不同维度的属性

- unary, binary, ternary
- prefix, postfix, infix, mixfix/distfix, closefix
- left associative, right associative
- precedence

---

在解析的时候，这些属性需要综合考虑。
不过整理后也不是很复杂，下面是些常见的例子。

- prefix, `-a` `!x` `++i`
- closefix `(a)`

- postfix, `i++`
- infix-left, `x+y` `x+y+z`
- infix-right, `x^y` `x^y^z`

- mixfix
    - `b?x:y` `X ? bb?bx:by : cc?cx:cy`
    - `a[i]` `a[ b[i] ]`
    - `fn(a1,a2)` `f1( f2() )`

---

- closefix 和 mixfix 都是两个符号组成
    - closefix 是 unary
    - mixfix 是 ternary
    - 实现时，都要考虑两个符号的匹配
- associative 在实现上，可以靠 precedence 解决
    - mixfix 可以重置 precedence
    - infix 可以增加一个是否相等的判断
- prefix 和 closefix 会先读取 operator，其他类型都是先读取 operand
    - 实现时，可以先判断之前是否有 operand，来确定接下来是 prefix/closefix，还是另外一种
    - 先进行一次 lookbehind，来判断 lookahead 是什么

吐槽一句
语法，确实是人为的给自己造成困难。
全部 lisp 就完全不需要这些操作了……
