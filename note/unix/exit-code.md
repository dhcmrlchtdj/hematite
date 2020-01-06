# exit code

https://www.tldp.org/LDP/abs/html/exitcodes.html
https://wiki.jenkins.io/display/JENKINS/Job+Exit+Status

之前只知道 exit 非 0 表示异常，其他没仔细去了解。
最近碰到一个 exit 999 变成 exit 231 的问题。
去查了下文档

---

- exit code 的取值范围是 0~255
- 超出范围的值，会被 `n%256`。所以前面 999 变成了 999%256=231
- 部分值有特殊含义
    - 比如 1, 2, 126, 127, 128, 128+signal (1~31), 255
    - 还有 man 3 sysexits (https://www.freebsd.org/cgi/man.cgi?query=sysexits)，定义了 64~78
- 想要自定义，就在剩下的值里挑吧
