# letsencrypt ECC

---

https://github.com/diafygi/acme-tiny
http://security.stackexchange.com/questions/78621/which-elliptic-curve-should-i-use
https://imququ.com/post/letsencrypt-certificate.html

---

```
# 创建 account private key
$ openssl genrsa 4096 > account.key

# 创建 domain private key
$ openssl ecparam -genkey -name secp384r1 -out domain.key
$ # openssl genrsa 4096 > domain.key # 如果要用 RSA 的话

# 生成 CSR (certificate signing request)
$ openssl req -new -sha384 -key domain.key -subj "/CN=yoursite.com" > domain.csr
$ # openssl req -new -sha384 -key domain.key -subj "/CN=yoursite.com" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:yoursite.com,DNS:www.yoursite.com")) > domain.csr

# 获取证书
$ curl -O 'https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py'
$ mkdir -p /opt/www/challenges/
$ python acme_tiny.py --account-key ./account.key --csr ./domain.csr --acme-dir /opt/www/challenges/ > signed.crt

# 获取中间证书，生成证书链
$ curl -s 'https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem' -o intermediate.pem
$ cat signed.crt intermediate.pem > chained.pem
```

可选的 ECC 曲线有很多种，可以看 `openssl ecparam -list_curves` 的输出。
前文链接里说，最少上 `prime256v1` 。
而 `secp384r1` 的开销不比 `prime256v1` 大多少，干脆就更安全一点吧。

配置好 nginx 就可以跑起来了。

```
ssl_certificate /path/to/chained.pem;
ssl_certificate_key /path/to/domain.key;
```

---

```
$ # 检查证书的过期时间
$ openssl x509 -noout -enddate -in chained.pem

$ # 检查 CSR 的内容
$ openssl req -noout -text -in domain.csr
```

---

```Makefile
SHELL := /bin/bash

certs := /path/to/certs
challenges := /path/to/challenges
CN := example.com
SAN := DNS:example.com,DNS:www.example.com

show:
	@make -nprR | sed -ne '/^$$/{ n; /^[^#.]/{ s/:.*//; p; }; }' | sort -u


account:
	mkdir -p $(certs)
	if [[ ! -f $(certs)/account.key ]]; then \
		openssl genrsa 4096 > $(certs)/account.key; fi

csr:
	mkdir -p $(certs)/$(CN)
	openssl ecparam -genkey -name secp384r1 -out $(certs)/$(CN)/domain.key
	openssl req -new -sha384 -key $(certs)/$(CN)/domain.key \
		-subj "/CN=$(CN)" -reqexts SAN \
		-config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=$(SAN)")) \
		> $(certs)/$(CN)/domain.csr

verify:
	mkdir -p $(challenges)
	if [[ ! -f $(certs)/acme_tiny.py ]]; then \
		curl -s 'https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py' \
		-o $(certs)/acme-tiny.py; fi
	python $(certs)/acme_tiny.py --account-key $(certs)/account.key \
		--csr $(certs)/$(CN)/domain.csr --acme-dir $(challenges) \
		> $(certs)/$(CN)/signed.crt

concat:
	if [[ ! -f $(certs)/intermediate.pem ]]; then \
		curl -s 'https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem' \
		-o $(certs)/intermediate.pem; fi
	cat $(certs)/$(CN)/signed.crt $(certs)/intermediate.pem \
		> $(certs)/$(CN)/chained.pem

sign: | account csr verify concat
```
