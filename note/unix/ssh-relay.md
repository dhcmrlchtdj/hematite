# ssh relay

---

以前看过一次，没记下来，结果碰到类似问题又搜了好久。

---

```
Host <relay>
    User <user>
    HostName <ip>
    Port <port>

Host <server>
    User <user>
    HostName <ip>
    Port <port>
    ProxyCommand ssh <relay> -W %h:%p
```

使用 `ProxyCommand` 来自动登录跳板机

---

有了个简化的 `ProxyJump`

```
Host <server>
    User <user>
    HostName <ip>
    Port <port>
    ProxyJump <relay>
```
