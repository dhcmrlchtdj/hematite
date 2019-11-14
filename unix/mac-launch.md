# mac launch

---

### launch

---

http://www.grivet-tools.com/blog/2014/launchdaemons-vs-launchagents/
https://www.jianshu.com/p/bfb5e9c90c8d

---

`launchctl list` 可以列出当前启动的服务

---

删除一些没用的自启动项

LaunchDaemons - run at boot
LaunchAgents - run at login

```
$ ll /Library/LaunchDaemons/
$ ll ~/Library/LaunchDaemons/
$ ll /System/Library/LaunchDaemons/

$ ll /Library/LaunchAgents/
$ ll ~/Library/LaunchAgents/
$ ll /System/Library/LaunchAgents/

$ ll /Library/StartupItems/
$ ll /System/Library/StartupItems/
```

不爽的都删除就是了

---

### kext

---

然后还有一个 kext

`kextstat | grep -v 'apple'` 可以列出当前的 kext

`kextunload -b 'com.example'` 顺利的话可以直接干掉

但有一些比较顽固的

```
$ ll /System/Library/Extensions/
$ ll /Library/Extensions/
```

删之

---

### debug / stdin and stdout

https://erikslab.com/2011/02/04/logging-with-launchd/

```
<key>StandardOutPath</key>
<string>/var/log/progname.log</string>
<key>StandardErrorPath</key>
<string>/var/log/progname_err.log</string>
```
