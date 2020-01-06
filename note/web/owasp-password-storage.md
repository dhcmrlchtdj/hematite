# password storage

---

https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet
http://stackoverflow.com/questions/2449594/how-does-a-cryptographically-secure-random-number-generator-work

---

## Do not limit the character set and set long max lengths for credentials

+ 不限制长度和字符集
+ A reasonable long password length is 160
    Very long password policies can lead to DOS in certain circumstances

---

## Use a cryptographically strong credential-specific salt

+ salt is fixed-length cryptographically-strong random value
+ `[protected form] = [salt] + protect([protection func], [salt] + [credential])`
+ `algorithm$salt:costfactor$hash` by https://github.com/mitsuhiko/python-pbkdf2/blob/master/pbkdf2.py

所谓 `credential-specific salts`，应该满足
+ 每次存储密码使用的 salt 都不同
+ 使用 `cryptographically-strong` 的随机数据作为 salt，随机性
+ 条件许可时，使用 32bit 或 64bit 产股的 salt
+ 不需要隐藏 salt

salt 可以防止出现两个相同的密码，可以在不依赖原密码的情况下增加复杂度。

---

## Impose infeasible verification on attacker

加密函数要在满足日常使用的同时，加大攻击的破解难度。

### Leverage an adaptive one-way function

加密过程不可逆，而且加密过程对时间或空间等条件有要求。

比如 `PBKDF2` / `scrypt` / `bcrypt`，`[salt] + pbkdf2([salt], [credential], c=10000)`

缺点是不能有效防止彩虹表。

### Leverage Keyed functions

加密过程不可逆，加密时使用私钥。私钥会增加对时间或空间的需求。

比如 `HMAC`，`[salt] + HMAC-SHA-256([key], [salt] + [credential])`

能阻止彩虹表之类的攻击，不过相当是是把问题转换成了对私钥的保护。

---

## Design password storage assuming eventual compromise
