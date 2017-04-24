# irc channel

---

## add alias

```
/alias list
cs => msg ChanServ
ns => msg NickServ
as => msg alis

/alias add as msg alis
```

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

---

## forward channel


https://freenode.net/kb/answer/channelmodes

- 首先要无法进入（比如 `+i`，也可以是其他限制
- 然后有个转发 `+f #new-ch`

```
/cs set #old-ch mlock +inpsf #new-ch

/cs info #old-ch
```

---

## automatic voice

```
/cs flags #ch *!*@* +Vv
```

---

### search channel

```
/as list *css*
/as list * -topic *js*
```
