# read

http://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html
http://ryanstutorials.net/bash-scripting-tutorial/bash-input.php

---

一直都是用 `$n` 的形式读取变量，现在才知道 `read` 这么好用

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
