# kotlin

---

- package / import
    - package 就是个命名空间
- function
    - `fun main() {...}` 里要写 `return`
    - `fun main() = ...` 不需要

---

## class

```kotlin
class Empty
class Invoice { ... }

// primary constructor
class Person(name: String) {}
class Person constructor(name: String) {}

// field
class Person(name: String) {
    val upper = name.toUpperCase()
}

// initializer blocks
class Person(name: String) {
    val upper = name.toUpperCase()
    init { println("First initializer block that prints ${name}") }
}

// secondary constructors
class Person {
    var children: MutableList<Person> = mutableListOf<Person>()
    constructor(parent: Person) { parent.children.add(this) }
}
// each secondary constructor needs to delegate to the primary constructor
// initializer blocks are part of the primary constructor
class Person {
    init { println("init") }
    constructor(name: String) { println("secondary") }
}
class Person(name: String) {
    var children: MutableList<Person> = mutableListOf<Person>()
    init { println("init") }
    constructor(name: String, parent:Person):this(name) { parent.children.add(this) }
}
```
