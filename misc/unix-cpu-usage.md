# cpu usage

---

http://unix.stackexchange.com/questions/18918/in-linux-top-command-what-are-us-sy-ni-id-wa-hi-si-and-st-for-cpu-usage

---

+ us: user cpu time      / user space
+ sy: system cpu time    / kernel space
+ ni: user nice cpu time / low priority processes
+ id: idle cpu time      / idle
+ wa: io wait cpu time   / wait (on disk)
+ hi: hardware irq       / servicing/handling hardware interrupts
+ si: software irq       / servicing/handling software interrupts
+ st: steal time         / the real CPU was not available to the current virtual machine

---

比如
dstat 默认输出了 `usr/sys/idl/wai/stl`
htop 默认输出了 `sy/ni/hi/si/st/wa`
