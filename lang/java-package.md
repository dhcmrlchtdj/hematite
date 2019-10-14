# java package

---

## package

- namespace
- `import java.time.*` has no negative effect on code size
    - `*` only work for single package
- static import
    - import static method/field
    - `import static java.lang.System.out`
- `package` statement
    - `package example.package.name`
- class path
    - `/home/username/java-class-dir/`
    - `/home/username/project/lib.jar`
    - classpath 可以包括目录（绝对路径或者当前目录 `.`）和 jar
    - 可以通过 `*` 引入目录下所有 jar，例 `/home/username/project/*`
- search `example.package.name.SomeClass` 会先找 JavaAPI，没有再遍历 classpath 查找
    - 如果通过 `import example.package.name.*` 的方式引入 `SomeClass`，会构造并查找 `example.package.name.SomeClass`
    - 如果存在多个 `import xxx.*`，会一个个构造查找过去（命名冲突会报错

---

## jar

- manifest
    - `/META-INF/MANIFEST.MF`
        - `Manifest-Version: 1.0` 就只有这么一行
    - `/META-INF/versions/9/A.class`
        - Multi-release JAR
        - java9 会使用 versions 下面的 A.class

---

## module


