# bash source path

---

http://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts

---

```sh
METHOD_A="$(dirname $0)"
METHOD_B="${BASH_SOURCE%/*}"
source "${METHOD}/other_script.sh"
```
