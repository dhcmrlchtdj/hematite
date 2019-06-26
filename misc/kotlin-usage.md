# kotlin

---

## kotlin js

```
$ cat a.kt
fun main() = println("hello")

$ kotlinc-js -verbose -module-kind commonjs -output a.kt.js a.kt

$ yarn add kotlin
$ node a.kt.js

$ # kotlin-dce-js -verbose a.kt.js
$ # ???
```

---

### kotlin repl

```
$ kotlinc-jvm
```
---

## kotlin script

```
$ cat a.kts
println("hello")

$ kotlinc-jvm -script a.kts
```

---
