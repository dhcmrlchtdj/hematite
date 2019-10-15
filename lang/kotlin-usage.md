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

$ kotlinc -include-runtime -d a.jar a.kt
$ file a.jar
a.jar: Java archive data (JAR)
$ kotlin a.jar
```

---

### kotlin coroutine

```
$ cat a.kt
import kotlinx.coroutines.*
suspend fun main() = coroutineScope {
    launch {
        delay(1000)
        println("Kotlin Coroutines World!")
    }
    println("Hello")
}

$ curl -O https://repo1.maven.org/maven2/org/jetbrains/kotlinx/kotlinx-coroutines-core/1.3.0/kotlinx-coroutines-core-1.3.0.jar

$ kotlinc -cp kotlinx-coroutines-core-1.3.0.jar -include-runtime -d a.jar a.kt
$ kotlin -cp kotlinx-coroutines-core-1.3.0.jar:a.jar AKt
```
