# kotlin annotation

---

https://kotlinlang.org/docs/tutorials/kotlin-for-py/annotations.html

- annotations are pure data-containing classes, and do not contain any executable code
- some built-in annotations have an effect on the compilation process (such as @JvmStatic)
- custom annotations are only useful for providing metadata that can be inspected at runtime by the reflection system

---

https://kotlinlang.org/docs/reference/annotations.html

- declare
    - `annotation class Fancy`
    - 几乎可以修饰任何元素
    - 可以像 data class 一样加上字段 (annotation attribute
        - `annotation class LikeDataClass(val someValue:Int)`
    - annotation 本身也可以被 annotation 修饰
        - `@Target(AnnotationTarget.ANNOTATION_CLASS) annotation class Example`
- usage
    - `@Fancy 1`
    - 要修饰的元素前面加上就行
    - primary constructor 特别一些，`class Foo @Fancy constructor() {}` 里的 constructor 不能省略
    - applying an annotation is a regular constructor call
    - use-site target
        - `@get:Fancy val someProperty = 1`
        - 变成修饰 getter 而不是 property
