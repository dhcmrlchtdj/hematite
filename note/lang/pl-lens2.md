# lens

---

http://bugsquash.blogspot.com/2011/11/lenses-in-f.html

---

- f#, `aBook.Editor.Car.Mileage <- aBook.Editor.Car.Mileage + 1000`
- c#, `aBook.Editor.Car.Mileage += 1000`

> how can we implement something similar in F# with immutable records?
> can we gain back some of the convenience of mutable properties?

---

> The key is to make properties first-class values.

- `'a` is the record type and `'b` is the property type
- getter, `'a -> 'b`
- mutable setter, `'b -> 'a -> unit`
- immutable setter, `'b -> 'a -> 'a`

```fsharp
type Lens<'a,'b> = {
    Get: 'a -> 'b
    Set: 'b -> 'a -> 'a
}
```

> Lenses are closed under composition.
> It's also possible to lift lens operations to the State monad

---

> The general concept of lenses is that a lens allows to focus on a particular
> element in a data structure, both to view it and to update it.

> lenses can be described as well-behaved bidirectional transformations.
