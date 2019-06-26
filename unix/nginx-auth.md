# nginx auth

---

http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html
https://www.openssl.org/docs/manmaster/man1/passwd.html

---

```
location / {
	auth_basic "closed site";
	auth_basic_user_file /path/to/htpasswd;
}
```

看着很简单，问题是怎么生成 htpasswd 文件啦。

---

```
$ cat htpasswd
# comment
name1:password1
name2:password2:comment
name3:password3
```

格式是这样的，自己用 `openssl passwd` 生成一下 password 就可以了

---

`man /usr/share/man/man1/passwd.1ssl.gz` 不知道要怎么补全，本地就完整路径吧……

```
$ echo "USERNAME:$(openssl passwd -apr1 'PASSWORD')" >> /path/to/htpasswd

$ openssl passwd -crypt 'PASSWORD'
$ openssl passwd -1 'PASSWORD'
$ openssl passwd -apr1 'PASSWORD'
```

测试了一下，三种加密方式都能识别

---

`http://username:password@example.com/` 这个就不用说了吧
