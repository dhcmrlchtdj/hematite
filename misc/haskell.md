# haskell

---

https://www.haskell.org/tutorial/
http://www.cs.nott.ac.uk/~pszgmh/pih.html

---

- polymorphic type
    - `a` in `length :: [a] -> Int`
    - `a/b` in `fst :: (a,b) -> a`
- class constraint
    - `Num a` in `(+) :: Num a => a -> a -> a`
- class: collection of types that support certain overloaded operations

---

- conditional, `abs n = if n >= 0 then n else -n`
- guarded, `abs n = | n >= 0 = n | otherwise = -1`
- pattern matching, `not False = True` `not True = False`
    - wildcard `_`
    - tuple, `(a,b)`
    - list, `1:[2,3]`
- lambda, `\x -> x + x`
- operator, `(#) = \x -> (\y -> x # y)`
- comprehension
    - `[(x,y) | x <- [1..5], y <- [3,4]]`
    - `factors n = [x | x <- [1..n], mod n x == 0]`
- recursive
- high order function
    - `f . g = \x -> f (g x)`

---

- type declaration
    - just a new name for an existing type
    - `type String = [Char]`
- data declaration
    - new type with constructor functions
    - `data Bool = False | True`
    - `data Shape = Circle Float | Rect Float Float`
    - `data Maybe a = Nothing | Just a`
    - `data Nat = Zero | Succ Nat`
- newtype declaration
    - new type with only one constructor with a single argument
    - `newtype Nat = N Int`
    - efficiency than `data Nat = N Int`
- class declaration
    - `class Eq a where ...`
- instance declaration
    - `instance Eq Bool where ...`
- deriving instance
    - `data Bool = False | True deriving (Eq, Ord, Show, Read)`

---

- functor, `class Functor f where ...`
    - mapping a function over each element of a structure
    - 将函数应用于容器，得到新的容器

```haskell
class IFunctor f where
    fmap :: (a -> b) -> f a -> f b

instance IFunctor [] where
    -- fmap :: (a -> b) -> [a] -> [b]
    fmap g mx = map g mx

instance IFunctor Maybe where
    -- fmap :: (a -> b) -> Maybe a -> Maybe b
    fmap _ Nothing = Nothing
    fmap g (Just x) = Just (g x)

instance IFunctor IO where
    -- fmap :: (a -> b) -> IO a -> IO b
    fmap g mx = do
        x <- mx
        return (g x)
```

- applicative, `class Functor f => Applicative f where ...`
    - allow functions with any number of arguments to be mapped, rather than being restricted to functions with a single argument

```haskell
class IFunctor f => IApplicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b

instance IApplicative [] where
    -- pure :: a -> [a]
    pure x = [x]
    -- (<*>) :: [a -> b] -> [a] -> [b]
    gs <*> xs = [g x | g <- gs, x <- xs]

instance IApplicative Maybe where
    -- pure :: a -> Maybe a
    pure x = Just x
    -- (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
    Nothing <*> _ = Nothing
    (Just g) <*> mx = fmap g mx

instance IApplicative IO where
    -- pure :: a -> IO a
    pure x = return x
    -- (<*>) :: IO (a -> b) -> IO a -> IO b
    mg <*> mx = do
        g <- mg
        x <- mx
        return (g x)

```

- monad, `class Applicative m => Monad m where ...`
    - a monad is an applicative type m that supports return and >>= functions of the specified types

```haskell
class IApplicative m => IMonad m where
    (>>=) :: m a -> (a -> m b) -> m b
    return :: a -> m a
    return = pure

instance IMonad [] where
    -- (>>=) :: [a] -> (a -> [b]) -> [b]
    xs >>= f = [y | x <- xs, y <- f x]

instance IMonad Maybe where
    -- (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
    Nothing >>= _ = Nothing
    (Just x) >>= f = f x

instance IMonad IO where
    -- return :: a -> IO a
    return x = ...
    -- (>>=) :: IO a -> (a -> IO b) -> IO b
    mx >>= f = ...
```

---

> by defining an operation monadically, we can hide underlying machinery in a
> way that allows new features to be incorporated into the monad transparently.

- `(>>) :: m a -> m b -> m b`
- `(>>=) :: m a -> (a -> m b) -> m b`
- `do e1; e2` => `e1 >> e2`
- `do p <- e1; e2` => `e1 >>= \p -> e2`

---

## monads for functional programming

---

- exception
    - 每次函数调用，都要判断返回值是否为异常，然后执行下一步
- state
    - 每次调用都要传递当前状态，读取返回值的状态，传递给下一次调用
- output

这些操作，有共通的模式可以抽取出来，也就是 monad。
（其实这里的共通模式，都是下一步操作依赖于上一步的结果。

---

> A monad is a triple (M, unit, bind) consisting of a type constructor M and
> two operations of the given polymorphic types.

- `unit :: a -> M a`
- `bind :: M a -> (a -> M b) -> M b`

---

- `do a <- m; n` => `m >>= (\a -> n)` => `bind m (\a -> n)`
    - => `let a = m in n`

把前面那些操作里，重复出现的模式放在了 bind 操作里面，从而隐藏了细节。
所以 monad 被叫做 programmable semicolon 是有道理的，这里主要就是控制了执行顺序。

---


