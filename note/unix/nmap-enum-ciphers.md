# nmap enum ssl ciphers

---

https://nmap.org/nsedoc/scripts/ssl-enum-ciphers.html
http://superuser.com/questions/109213/how-do-i-list-the-ssl-tls-cipher-suites-a-particular-website-offers

---

```
$ nmap --script ssl-enum-ciphers -p 443 <host>
```

遍历网站支持的 cipher suites
