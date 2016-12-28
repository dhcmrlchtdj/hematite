# irc channel

---

修改权限
```
/cs op|deop #ch [nickname]
/cs voice|devoice #ch [nickname]
```

查看自己的权限
```
/cs status #ch
```

哪些人有频道的相关权限
```
/cs access #ch list
/cs help access
/cs help flags
```

flags（info 可以看到
```
/cs set #ch guard on

/cs set #ch secure on
/cs set #ch verbose ops

/cs set #ch private off
/cs set #ch restricted off

/cs set #ch keeptopic off
/cs set #ch topiclock off
```

mode（info 可以看到
https://freenode.net/kb/answer/channelmodes
```
/mode #ch [modes]
/cs set #ch mlock [modes]

/cs set #ch mlock +nps-itclk
```
