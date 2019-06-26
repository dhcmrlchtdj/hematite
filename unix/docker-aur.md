# docker aur

---

makepkg 不能以 root 运行，所以创建一个 build 用户

```dockerfile
FROM archlinux/base

RUN echo "[multilib]" >> /etc/pacman.conf
RUN echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
RUN pacman -Syu --noconfirm base base-devel

RUN useradd -m -s /bin/bash -d /build build
RUN echo "build ALL=NOPASSWD: ALL" >> /etc/sudoers
USER build

WORKDIR /build
RUN curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/nvm.tar.gz"
RUN bsdtar xvf nvm.tar.gz
WORKDIR /build/nvm
RUN makepkg -sr
RUN sudo pacman -U --noconfirm nvm-0.33.11-1-any.pkg.tar.xz
```
