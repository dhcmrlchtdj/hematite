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

- `type IO a = State -> (a, State)`
    - `getChar :: IO Char`
    - `putChar :: Char -> IO ()`

