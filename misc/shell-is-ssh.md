# is ssh?

---

http://unix.stackexchange.com/questions/9605/how-can-i-detect-if-the-shell-is-controlled-from-ssh
http://unix.stackexchange.com/questions/120080/what-are-ssh-tty-and-ssh-connection

---

```sh
is_ssh() {
    [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]
}
```
