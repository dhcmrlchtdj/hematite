# fail2ban test

---

fail2ban 修改后，可以用 `fail2ban-regex` 对 filter 进行测试

```
$ fail2ban-regex /path/to/log /path/to/conf -v
$ fail2ban-regex 'systemd-journal' /path/to/conf -v
```

---

fail2ban 有一点很奇怪的地方
总感觉它匹配的内容，和预期的内容不一致

---

自己测试规则的时候，把自己 ban 了……可以使用 `unbanip` 挽救一下。
`fail2ban-client set <jail-name> unbanip <ip-addr>`
