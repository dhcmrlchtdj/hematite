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
$ openssl req -new -sha384 \
    -subj "/CN=RootCA" \
    -x509 -days 365 \
    -key ca.key \
    -out ca.crt

$ openssl ecparam -genkey -name secp384r1 -out domain.key
$ openssl req -new -sha384 \
    -subj "/CN=example.com" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:example.com,DNS:*.example.com")) \
    -key domain.key \
    -out domain.csr
$ openssl x509 -req -sha384 \
    -extfile <(printf "subjectAltName=DNS:example.com,DNS:*.example.com") \
    -days 365 \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in domain.csr \
    -out domain.crt

$ openssl req -noout -text -in domain.csr
$ openssl x509 -noout -text -in domain.crt
$ openssl x509 -noout -text -in ca.crt
```
