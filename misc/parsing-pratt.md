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


