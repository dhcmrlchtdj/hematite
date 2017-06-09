# config for user

---

http://serverfault.com/questions/285800/how-to-disable-ssh-login-with-password-for-some-users
http://serverfault.com/questions/679425/best-way-to-restrict-some-ssh-users-to-publickey-authentication-only-disable-pa

---

sshd 里面也可以使用 `Match` 来针对用户进行某些配置。
比如限制 root 以外的用户只能用 key 登录

```
Match User !root
    AuthenticationMethods publickey
```

---

修改后，可以用 `sshd -t` 测试一下有没有错误。
