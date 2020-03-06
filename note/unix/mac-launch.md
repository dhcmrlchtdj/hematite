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

---

### submit

```
$ # 生成
$ launchctl submit -l 'label' -p '/path/to/executable' -o '/path/to/stdout' -e '/path/to/stderr'

$ # 删除/停止
$ launchctl remove 'label'

$ # 查看状态
$ launchctl list | grep -v 'com.apple'

$ # 重启
$ launchctl stop 'label'
```

~~不用写 plist 方便不少，其他查看 `man launchctl` 吧~~
试了下，开机后就没了……还是手写 plist 吧
