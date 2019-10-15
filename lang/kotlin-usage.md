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

$ kotlinc -script a.kts
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

$ kotlinc -d a.jar a.kt
$ file a.jar
a.jar: Java archive data (JAR)
$ kotlin -cp a.jar AKt
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

$ kotlinc -cp /usr/local/Cellar/kotlin/1.3.50/libexec/lib/kotlinx-coroutines-core-1.0.1.jar -d a.jar a.kt
$ kotlin -cp /usr/local/Cellar/kotlin/1.3.50/libexec/lib/kotlinx-coroutines-core-1.0.1.jar:a.jar Akt
$ # java -cp '/usr/local/Cellar/kotlin/1.3.50/libexec/lib/*':'./*' AKt
```

不想写 `java -cp ...` 的话，也可以直接加入 `CLASSPATH`。
`kotlin` 不支持在 `-cp` 里使用 `*`，这个感觉没 java 方便。
