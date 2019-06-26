# mostly adequate guide

---

https://github.com/MostlyAdequate/mostly-adequate-guide

---

## Hindley-Milner

- type signatures
	- `match :: Regex -> (String -> [String])`
	- `filter :: (a -> Bool) -> [a] -> [a]`
	- `reduce :: (b -> a -> b) -> b -> [a] -> b`
- constraints
	- `assertEqual :: (Eq a, Show a) => a -> a -> Assertion`
	- `sort :: Ord a => [a] -> [a]`
		- `a` must be an `Ord`
		- `a` must implement the `Ord` interface

---

## Functor

- A Functor is a type that implements `map` and obeys some laws
- 调用 map 的时候，把容器的值取出来传给 map，返回值放入新的容器

```js
class Identity {
    constructor(x) {
        this.__value = x;
    }
    map(f) {
        return Identity.of(f(this.__value));
    }
    static of(x) {
        return new Identity(x);
    }
}
Identity.of(2).map(x => x*2);
```

## Maybe

```
class Maybe {
    constructor(x) {
        this.__value = x;
    }
    static of(x) {
        return new Maybe(x);
    }
    isNothing() {
        return (this.__value === null || this.__value === undefined);
    }
    map(f) {
        return this.isNothing() ? Maybe.of(null) : Maybe.of(f(this.__value));
    }
}
Maybe.of(2).map(x => x*2).map(x => null).map(x => x*2);
Maybe.of(null).map(x => x*2);

const maybe = (m) => m.__value;
```

## Either

- error handle

## IO

```
const compose = (f, g) => (...args) => f(g(...args));
class IO {
    constructor(f) {
        // this.__value = f;
        this.unsafePerformIO = f;
    }
    static of(f) {
        return new IO(f);
    }
    map(f) {
        return IO.of(compose(f, this.unsafePerformIO));
    }
}

IO.of(() => window).map(win => win.innerWidth);
IO.of(() => window).map(win => win.innerWidth).unsafePerformIO();
```

- the `__value` is always a function
- do not think of `__value` as a function
- 虽然实际是个函数，但这是实现上的细节，理解时忽略掉

---

## Pointed

- A pointed functor is a functor with an `of` method

## Monad

- Monads are pointed functors that can flatten

```js
Maybe.prototype.join = function() {
    return this.isNothing() ? Maybe.of(null) : this.__value;
};

IO.prototype.join = function() {
    return IO.of(() => this.unsafePerformIO().unsafePerformIO());
};
```

## chain

```js
// flatMap :: Monad m => (a -> m b) -> m a -> m b
const flatMap = (f, m) => m.map(f).join();
const chain = flatMap;
```

---

## Applicative Functors

- An applicative functor is a pointed functor with an `ap` method

```
Identity.prototype.ap = function(other_container) {
    return other_container.map(this.__value);
};
```

- `F.of(x).map(f) == F.of(f).ap(F.of(x))`
- `A.of(f).ap(A.of(x)) == A.of(f(x))`
- `v.ap(A.of(x)) == A.of(f => f(x)).ap(v)
