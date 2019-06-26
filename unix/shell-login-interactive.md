# shell login interactive

用了这么多年 linux，始终没分清各种 shell。
结果这次搞 jenkins 里 docker 的 shell 就碰到坑了。
要怎么才能在每个 shell 命令前执行一些脚本呢？

---

以下来自 `man bash`

- `login` 和 `interactive` 是相互独立的概念
- `login shell`，用 `--login` 参数启动的 shell
- `interactive shell`，不带 non-option arguments 启动的 shell
- `login` 会去读取 `~/.profile`，`interactive` 会去读取 `~/.bashrc`
    - `login`
        - `/etc/profile`
        - `~/.profile`
        - `~/.bash_profile`
        - `~/.bash_login`
        - `~/.bash_logout`
    - `interactive`
        - `~/.bashrc`
    - `sh` 会在 `interactive+login` 时读取 `profile`，不会读 bash 的配置

---

> A non-interactive shell invoked with the name sh does not  attempt to read any
> other startup files.

jenkinsfile 这个场景下，使用方式就是 `sh "..."`，感觉没救了。
