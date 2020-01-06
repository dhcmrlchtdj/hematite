# erlang

---

http://erlang.org/doc/getting_started/users_guide.html

---

好想像 reason 一样搞个所谓的的 new interface，如果有这个能力的话。

---

+ 每个语句后面要 `.`，开始出错都不知道问题在哪。再想想，不就是 `;` 吗……
+ 代码里的模块名要和文件名一致，那为什么代码还要申明模块名啊。
+ 上来就劈头盖脸的模式匹配。
+ 小写开头 Atom，大写开头 Variables，是觉得符号不够用吗。
+ 没有 String，只有 unicode List，所以字符数组还是字符串只能靠猜了？
+ `{}` 的 Tuple，`#{ k => v }` 的 Map，修改时的 `M#{ k:=v }`，只能说语法不合群。
+ manpage 为什么不装到系统路径下面
+ 所以还是有 `"abc"` 这种简写呀。但转义为什么是 `~w` 不是 `%s`，故意的吗。
+ 这条件语句谁想出来的。`A,B` 是 and，`A;B` 是 or，前面还见过 `andalso`，醉了……
+ 之前函数最后是 `.`，到了 Higher-Order Functions 最后要 `end` 了。一致性呢。


---

http://joearms.github.io/2013/05/31/a-week-with-elixir.html

---

> The Three Laws of Programming Language Design

> + What you get right, nobody mentions it.
> + What you get wrong, people bitch about.
> + What is difficult to understand you have to explain to people over and over again.

---

> I have explained why so many times that my hair has gone grey, it's true my
> hair is now grey because of this.

> If you don't fix this you'll spend the next 20 years explain why - just like
> we did in Erlang.

> If you leave it like this expect to spend the next twenty years of your life
> explaining why. Expect thousands of mails in hundreds of forums.

哈哈哈，怨念好深。

---

http://joearms.github.io/2013/04/05/concurrent-and-parallel-programming.html

---

> Concurrent = Two queues and one coffee machine.
> Parallel = Two queues and two coffee machines.

简单明了
