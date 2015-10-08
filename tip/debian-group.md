# group

---

```
# list all group
$ cat /etc/group

# list group user
$ getent group [group]

# list current user group
$ groups [user]

# add/del from group
$ gpasswd -a [user] [group]
$ gpasswd -d [user] [group]
```
