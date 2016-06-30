# ssh key

---

## 生成

```
$ ssh-keygen -t ed25519 -o -a $number -C "$(whoami)@$(hostname)@$(date +%F)"
$ ssh-keygen -t rsa -b 4096 -o -a $number -C "$(whoami)@$(hostname)@$(date +%F)"
$ # ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)"
```

`number` 设为 1000 时，连接就要花上 30s，自己看情况设吧

---

## 保护

在服务器上设置只读

```
$ chmod 400 ~/.ssh/authorized_keys
```

---

## 修改密码

```
$ ssh-keygen -p -f /path/to/private-key
```

---

## 免输入

```
$ ssh-add -l
$ ssh-add -D
$ ssh-add -c /path/to/private-key
```
