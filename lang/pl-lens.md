# lens

---

https://artyom.me/lens-over-tea-1
http://www.haskellforall.com/2013/05/program-imperatively-using-haskell.html
https://en.wikibooks.org/wiki/Haskell/Lenses_and_functional_references

---

> A lens allows us to get some value from a Big Value,
> and to update some value in the Big Value.

---

> getter + setter = lens

```haskell
data Lens s a = Lens { getter :: s -> a, setter :: a -> s -> s }
ix :: Int -> Lens [a] a
```

比如这个例子，ix 签名就是输入 int，返回 getter::[a]->a,setter::a->[a]->[a]

```haskell
type Lens s a = (a -> a) -> s -> (a, s)
-- ix :: Int -> (a -> a) -> [a] -> (a, [a])
ix :: Int -> Lens [a] a
```

作者提供的一个优化版本。
要 get 可以用 identity 做参数，用 fst 取数据；要 set 可以用 snd 取修改后的值。

```haskell
{-# LANGUAGE RankNTypes #-}
type Lens s a = Monad m => (a -> m a) -> s -> (a, m s)
-- ix :: Int -> (a -> [a]) -> [a] -> (a, [[a]])
ix :: Int -> Lens [a] a

type Lens s a = Functor f => (a -> f a) -> s -> (a, f s)
-- ix :: Int -> (a -> [a]) -> [a] -> (a, [[a]])
ix :: Int -> Lens [a] a
```

---

getter 本身倒是没什么问题，相当于提前写好了取数据的模版，然后把数据丢进去。
问题是 getter，假设对象是不可变的，那么 setter 修改数据后就生成的一个新的对象。
这个时候，之前定义的 getter/setter 还能正确指向相应数据吗？
每次调用 getter/setter 都必须把对象作为参数传递进去？这样的话使用起来并没有简化吧？
而且如果是 A -> lens B -> lens C，对 C 的修改应该反应到 A 吧，此时 B 能够知道吗？
A 本身又如何知道呢？
从前面的例子看，setter 改了数据后，什么都没管。

回答下上面的问题
- 数据源，每次都作为参数输入。执向正确数据靠调用来保证。data last 的思路。
- ABC 这个，做法是 compose 好，直接输入 A 返回 A

---

> A lens allows us to do something to a big structure given that we know how to
> do something to a part of it.

> There are many reasons why lenses are awesome, but performance isn't one of
> them.

---

https://github.com/grammarly/focal

---

从 focal 的例子看，做法是靠 observable 来向上反馈，层层更新。
这种做法，我很难看出和双向绑定的差异在哪里。
双向绑定，computed 导致计算顺序混乱的问题，如何解决的呢。

---

其实在 babel 里也有类似的问题吧，最近在搞的插件顺序。
UI 上这种数据更新问题和 babel 这种插件执行顺序的问题，其实内在应该是非常相似的。
想知道正确的做法。
