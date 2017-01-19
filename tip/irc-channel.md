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
/cs flags #ch
/cs help flags

/cs access #ch list
/cs help access
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

---

## private channel

https://botbot.me/how-to-setup-irc-channel/
https://freenode.net/kb/answer/extbans

```
/cs set #ch mlock +inpsr-tclk

/mode #ch +I
/mode #ch +I $a:<account-name>
/mode #ch +I $r:<nick-name>
```
