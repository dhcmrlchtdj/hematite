# xcode path

---

http://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error

---

```
$ xcodebuild -version
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance

$ xcode-select -p
/Library/Developer/CommandLineTools
```

遇到上面这样的报错。
以前出于什么目的改了下 active developer directory 这个变量，忘记了。

直接重置一下，什么时候想起当初什么问题了，再看怎么改吧……

```
$ xcode-select -r

$ xcode-select -p
/Applications/Xcode.app/Contents/Developer
```

---

好吧，原来是上次安装 gentoo prefix 遗留的……
~~重新 `xcode-select --install` 也可以的~~

测试之后，不行呀
gentoo prefix 之后把 xcode-select 的路径改回来吧
