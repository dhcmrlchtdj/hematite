# redirection

---

https://www.gnu.org/software/bash/manual/bashref.html#Redirections
http://wiki.bash-hackers.org/howto/redirection_tutorial
http://wiki.bash-hackers.org/syntax/redirection

---

在 #archlinux-cn 看到有人问起 `command strace "$@" 3>&1 1>&2 2>&3` 里 3 是什么。
发现自己也看懵了，所以去查了点资料

翻了一圈，然后发现还是 manpage 好

---

+ Redirecting Input
	- `[n]<word`
+ Redirecting Output
	- `[n]>word`
	- 如果启用了 `noclobber`，在 `word` 存在的情况下，写入会报错
	- 可以用 `[n]>|word` 来无视 `noclobber` 强制写入
+ Appending Redirected Output
	- `[n]>>word`
+ Redirecting Standard Output and Standard Error
	- `>word 2>&1`
	- `&>word`，不推荐
	- `>&word`，不推荐
+ Appending Standard Output and Standard Error
	- `>>word 2>&1`
	- `&>>word`，不推荐
+ Here Documents
	- `<<[-]word \n here-document \n delimiter`
	- `<<-` 的时候，会把 here-document 每行前面的 tab 去掉
	- 如果 `word` 被引号包裹，here-document 就是原原本本的字符串
	- 如果 `word` 没引号包裹，here-document 会进行各种 shell 字符串的展开、替换等
+ Here Strings
	- `<<<word`
+ Duplicating File Descriptors
	- `[n]<&word`
	- `[n]>&word`
	- `&-` 是关闭的意思，比如 `0<&- 2>&-` 就关闭输入和错误
+ Moving File Descriptors
	- `[n]<&digit-`
	- `[n]>&digit-`
	- `n` 指向 `digit`，然后 `digit` 关闭掉
+ Opening File Descriptors for Reading and Writing
	- `[n]<>word`

多个组合的情况，顺序从左到右
