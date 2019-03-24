# gradle

---

一个普通的 kotlin 项目长这样

```
.
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── src/
│   ├── main/
│   │   └── kotlin/
│   │       └── tadpole/
│   │           └── Main.kt
│   └── test/
│       └── kotlin/
│           └── tadpole/
│               └── MainTest.kt
├── build.gradle.kts
├── gradlew*
├── gradlew.bat
└── settings.gradle.kts
```

可以通过 `gradle init` 生成项目，也可以 `gradle wrapper` 在项目里生成配置文件。
init 的模版可能有点旧，直接 wrapper 更方便。

---

国内网络太差，可以考虑用 aliyun 的镜像

https://docs.gradle.org/current/userguide/declaring_repositories.html#sec:declaring_multiple_repositories
https://docs.gradle.org/current/userguide/plugins.html#sec:custom_plugin_repositories
https://maven.aliyun.com/mvn/view

需要修改 `build.gradle.kts` 及 `settings.gradle.kts`

```
$ cat settings.gradle.kts
pluginManagement {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
    }
}
...

$ cat build.gradle.kts
...
repositories {
    maven { url = uri("https://maven.aliyun.com/repository/jcenter") }
    maven { url = uri("https://maven.aliyun.com/repository/central") }
}
```

这里 maven 是指仓库的类型（对应的还有 ivy 类型）
后面是具体的源地址，有 maven central / jcenter / google 各家的，全部改用 aliyun 的镜像即可

其实 gradle/wrapper/gradle-wrapper.properties 里还有个 distributionUrl。
不过下载速度还行，一次性的事情，就不修改了。
（平常会选择直接用 homebrew 下载的 gradle（这也就是为什么喜欢用 gradle wrapper 了

---

- gradle run
- gradle test
- gradle build / clean

平常会用到的，也就这些。

java 下面安装依赖都要手动修改配置文件，感觉有点傻啊
