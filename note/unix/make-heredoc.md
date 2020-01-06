# makefile heredoc

---

可以这么写

```
define SOME_VARIABLE
	line1
	line2
endef
export SOME_VARIABLE

target:
	echo "$$SOME_VARIABLE"
```
