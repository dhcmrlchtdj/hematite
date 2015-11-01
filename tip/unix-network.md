# iputils

`iputils` 提供了 `ping` 和 `tracepath`

基本的连接情况

```
$ ping -c3 google.com
$ tracepath -n google.com
```

---

# ldns

`ldns` 提供了 `drill`

dns 查询

```
$ drill google.com
```

---

# traceroute

`traceroute` 和 `tracepath` 功能接近

```
$ traceroute -n google.com
```

---

# bind

`bind-tools` 提供了 `dig` `nslookup` `host`

```
$ dig google.com
$ host google.com
$ nslookup google.com
```
