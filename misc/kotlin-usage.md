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

## kotlin script

```
$ cat a.kts
println("hello")

$ kotlinc-jvm -script a.kts
```

---

### kotlin repl

```
$ kotlinc
```
---

### kotlin jar

```
$ cat a.kt
fun main() = println("hello")

$ kotlinc a.kt
$ file AKt.class
AKt.class: compiled Java class data, version 50.0 (Java 1.6)
$ kotlin AKt

$ kotlinc -d a.jar -include-runtime a.kt
$ file a.jar
a.jar: Java archive data (JAR)
$ kotlin a.jar
```
