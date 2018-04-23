# bash die

---

http://stackoverflow.com/questions/7868818/in-bash-is-there-an-equivalent-of-die-error-msg
https://github.com/martinburger/bash-common-helpers/blob/master/bash-common-helpers.sh

---

已经忘记最早在哪看到用 `die` 来报错了。
今天写测试又想起来有这么个东西

---

```bash
function die {
	local red=$(tput setaf 1)
	local reset=$(tput sgr0)
	echo >&2 -e "${red}$@${reset}"
	exit 1
}
```
