# ssh key

## 生成

```
$ ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)"
```


## 保护

在服务器上设置只读

```
$ chmod 400 ~/.ssh/authorized_keys
```
