# self signed certification

---

https://security.stackexchange.com/questions/74345/provide-subjectaltname-to-openssl-directly-on-command-line/159537#159537

---

自签证书在 chrome 上异常，网上说是 SAN 的问题。
尝试多次还是配置不对，终于找到一个能用的。

```
openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 365 -key ca.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=Acme Root CA" -out ca.crt

openssl req -newkey rsa:2048 -nodes -keyout server.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=*.example.com" -out server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:example.com,DNS:*.example.com") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```

---

按自己理解，改造一下

```
$ openssl ecparam -genkey -name secp384r1 -out ca.key
$ openssl req -new -x509 -days 365 -key ca.key -subj "/C=CN/ST=BJ/O=company/CN=RootCA" -out ca.crt

$ openssl x509 -in ca.crt -text -noout


$ openssl x509 -in domain.crt -text -noout
```
