# fp jargon

---

https://github.com/hemanth/functional-programming-jargon
https://github.com/fantasyland/fantasy-land

---

## Functor

- functor is `object` that implement `map`
    - `[1,2,3].map(x => x)` = `[1,2,3]`
    - `[1,2,3].map(x => f(g(x)))` = `[1,2,3].map(f).map(g)`
- `array` is functor

---

## Pointed Functor

- pointed functor is `object` that implement `of`
    - `Array.of(1)`
- `Array` is pointed functor

---

## Lift

- ???
- lift is `function`
    - `lift(x=>x+1)([2])` = `[2].map(x=>x+1)` = `[3]`
    - `lift2 = (f) => (a, b) => a.map(f).ap(b)`

---

## Monoid

- monoid is `function` that combine object with same object
    - identity, `1 + 0` = `1`
    - associativity, `1 + (2 + 3)` = `(1 + 2) + 3`
- `+` for `number` is monoid
- `concat` for `array` is monoid

---

## Monad

- ???
- monad is `object` implement `of/return` and `chain/bind/flatmap`
    - `Array.of(1)` = `[1]`
    - `[1,2].flatmap(x => [x+1, x+2])` = `[2,3,3,4]`

---

## Comonad

- comonad is `object` implement `extract` and `extend`
    - `CoIdentity(1).extract()` = `1`
    - `CoIdentity(1).extend(co => co.extract() + 1)` = `CoIdentity(2)`

---

## Applicative Functor

- applicative functor is `object` implement `ap`
    - `[(a=>a+1)].ap([1])` = `[2]`

---

## Setoid

- setoid is `object` implement `equals`
    - `[1,2].equals([1,2])` = `true`

---

## Semigroup

- semigroup is `object` implement `concat`
    - `[1].concat([2])` = `[1,2]`
- `array` is semigroup

---

## Foldable

- foldable is `object` implement `reduce`
    - `[1,2,3].reduce((sum, n) => sum + n, 0)` = `6`
- `array` is foldable

---

感想，不解
给带方法的对象取个特别的名字有什么用呢？为什么不直接用方法来命名呢？
