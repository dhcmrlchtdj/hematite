# ansible adhoc

---

http://docs.ansible.com/ansible/intro_adhoc.html

---

配置好之后，可以在远程执行某些操作

```
$ ansible all -a "ls"
$ ansible all -m shell -a "ls"
```

需要权限的命令，可以使用 become

```
$ ansible all -m shell -a 'sudo pacman -Syu --noconfirm' -b --ask-become-pass
```
