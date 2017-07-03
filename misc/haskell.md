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


