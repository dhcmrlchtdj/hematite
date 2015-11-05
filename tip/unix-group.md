# group

---

https://wiki.archlinux.org/index.php/Users_and_groups
http://unix.stackexchange.com/questions/18796/how-to-apply-changes-of-newly-added-user-groups-without-needing-to-reboot

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

# apply group change
$ newgrp [group]
```
