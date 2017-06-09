# read

http://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html
http://ryanstutorials.net/bash-scripting-tutorial/bash-input.php

---

一直都是用 `$n` 的形式读取变量，没试过用 `read` 读取输入

```sh
#!/usr/bin/env bash

read -p 'Username: ' username
read -sp 'Password: ' password
echo $username $password
```

```sh
#!/usr/bin/env bash

read oldrev newrev ref
echo $oldrev $newrev $ref
```
