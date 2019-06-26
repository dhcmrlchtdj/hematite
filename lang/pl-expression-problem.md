# expression problem

---

https://en.wikipedia.org/wiki/Expression_problem
https://cs.brown.edu/~sk/Publications/Papers/Published/kff-synth-fp-oo/
https://eli.thegreenplace.net/2016/the-expression-problem-and-its-solutions/
http://journal.stuffwithstuff.com/2010/10/01/solving-the-expression-problem/
http://wiki.c2.com/?ExpressionProblem

---

之前就知道这东西，但是不知道这就叫做 expression problem。

> The goal is to define a datatype by cases, where one can add new cases to the
> datatype and new functions over the datatype, without recompiling existing
> code, and while retaining static type safety (e.g., no casts).

---

```ocaml
type shape =
    | Square of float
    | Circle of float

let area = function
    | Square w -> w *. w
    | Circle r -> r *. r *. 3.14

let ss = [Square 10.; Circle 10.]
let areas = List.map area ss
```

```typescript
class Shape {
    area() {
        throw new Error('not implement');
    }
}

class Square extends Shape {
    public w: number;
    constructor(w) {
        super();
        this.w = w;
    }
    area() {
        return this.w * this.w;
    }
}

class Circle extends Shape {
    public r: number;
    constructor(r) {
        super();
        this.r = r;
    }
    area() {
        return this.r * this.r * 3.14;
    }
}

const ss = [new Square(10), new Circle(10)];
const areas = ss.map(s => s.area());
```

上面两个例子

ocaml 里是以操作为维度去组织代码。
所以新增操作（比如求周长）比较简单。
但是新增类型（比如长方形）就要修改原有代码了。

js 里面是以类型为维度去组织代码。
所以新增类型比较简单。
但是新增操作要修改源代码。

---

visitor 用在 OO 上，可以改变组织代码的维度。
（但问题似乎就转换成 FP 那边不易新增类型了？

```typescript
interface IShapeVisitor {
    forSquare: (s: Square) => number;
    forCircle: (s: Circle) => number;
}

abstract class Shape {
    abstract accept(ask: IShapeVisitor): number;
}

class Square extends Shape {
    public w: number;
    constructor(w: number) {
        super();
        this.w = w;
    }
    accept(ask: IShapeVisitor): number {
        return ask.forSquare(this);
    }
}

class Circle extends Shape {
    public r: number;
    constructor(r: number) {
        super();
        this.r = r;
    }
    accept(ask: IShapeVisitor): number {
        return ask.forCircle(this);
    }
}

class AreaVisitor implements IShapeVisitor {
    forSquare(s: Square): number {
        return s.w * s.w;
    }
    forCircle(s: Circle): number {
        return s.r * s.r * 3.14;
    }
}

const ss = [new Square(10), new Circle(10)];
const areas = ss.map(s => s.accept(new AreaVisitor()));
```

具体操作，都汇总到了 visitor 里面，新增操作就是新增 visitor。

> we're using an OOP language, but now it's hard to add types and easy to add
> ops, just like in the functional approach.

如果要新增 shape 要怎么办呢。

---

插入一点，在 ocaml 里面可以这么搞

```ocaml
type shape = [
    | `Square of float
    | `Circle of float
]
let area = function
    | `Square w -> w *. w
    | `Circle r -> r *. r *. 3.14

type shape_extend = [
    | shape
    | `Rectangle of float * float
]
let area_extend = function
    | #shape as s -> area s
    | `Rectangle (w, h) -> w *. h

let ss = [`Square 10.; `Circle 10.; `Rectangle(10., 10.)]
let areas = List.map area_extend ss
```

之后都使用扩展过的方法就可以
但感觉这不是一个通用的方法……

---

在 js 里面的话，大概可以这样

```typescript
class Rectangle extends Shape {
    public w: number;
    public h: number;
    constructor(w: number, h: number) {
        super();
        this.w = w;
        this.h = h;
    }
    accept(ask: IShapeExtendedVisitor): number {
        return ask.forRectangle(this);
    }
}

interface IShapeExtendedVisitor extends IShapeVisitor {
    forRectangle: (s: Rectangle) => number;
}

class AreaExtenedVisitor extends AreaVisitor implements IShapeExtendedVisitor {
    forRectangle(s: Rectangle): number {
        return s.w * s.h;
    }
}

const ss = [new Square(10), new Circle(10), new Rectangle(10, 10)];
const areas = ss.map(s => s.accept(new AreaExtenedVisitor()));
```

定义新的类型，定义新的接口，定义新的 visitor。
新 visitor 继承旧的 visitor，同时实现新接口，支持新类型。

---

以前看 a few java 的时候，懂得还不够多呀。
