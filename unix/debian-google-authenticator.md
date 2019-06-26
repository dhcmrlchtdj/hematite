# debian google authenticator

---

https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-two-factor-authentication
https://wiki.archlinux.org/index.php/Google_Authenticator

---

安装依赖

```
$ sudo aptitude install libpam-google-authenticator
```

---

```
$ vim /etc/pam.d/sshd
```

添加如下配置

```
auth    required    pam_google_authenticator.so
```

---

```
$ vim /etc/ssh/sshd_config
```

添加如下配置

```
ChallengeResponseAuthentication yes
AuthenticationMethods publickey keyboard-interactive:pam # 随便满足一个
AuthenticationMethods publickey,keyboard-interactive:pam # 两个都要满足
```

---

```
$ google-authenticator
```

扫码。
