# expect

---

```sh
$ expect -c 'spawn ssh server; expect "password"; send "password"; interact'
```

---

在 `interact` 之后，还可以继续 `expect`

```expect
#!/usr/bin/expect
spawn ssh server;
expect {
    "password" {
        interact "\r" {
            send "\r";
            exp_continue;
        }
    }
    "~" {
        send "ls\r";
        exp_continue;
    }
}
```

上面这段代码，在要输入密码时，将控制权交给用户。
当用户输入 `\r`，也就是 `enter` 键，控制权重新交给程序，开始下一轮匹配。

---

```sh
alias relay="expect -c 'spawn ssh $SERVER_NAME; expect \"Password:\" {send \"$PASSWORD\"; interact} \"bash\" interact'"
```

---

expect 默认有超时限制，可以设为 -1 去掉限制。

```expect
set timeout -1
spawn ssh server
expect { ... }
```

---

如果要在 shell 里面直接写入多行的 expect，可以用 heredoc

```sh
cat << EOF | expect -
spawn ssh server
expect ...
EOF
```
