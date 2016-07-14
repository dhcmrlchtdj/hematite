# TTY

---

http://unix.stackexchange.com/questions/4126/what-is-the-exact-difference-between-a-terminal-a-shell-a-tty-and-a-con
http://unix.stackexchange.com/questions/21280/difference-between-pts-and-tty

---

+ tty / terminal
	- native terminal device
	- hardware or kernel emulated
+ pty / pseudo terminal interfaces
	- used for implementing terminal emulators
	- 比如 sshd / screen / xterm 等
+ pts / pseudo terminal slave
	- slave part of pty
+ ptmx / pseudo terminal master
	- master part of pty
