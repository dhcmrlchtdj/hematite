# sysctl

https://phuslu.github.io/sysctl.conf

```
# 系统所有进程一共可以打开的文件数量， 每个套接字也占用一个文件描述字
fs.file-max = 1491124
# 增大内核 backlog 参数，使得系统能够保持更多的尚未完成 TCP 三次握手的套接字。
net.ipv4.tcp_max_syn_backlog = 1048576
net.core.netdev_max_backlog = 1048576
net.core.somaxconn = 1048576
# 增大应用程序可用端口范围。
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.ip_local_reserved_ports = 3000,3306,6379,27017,27018
# 系统中最多有多少个 TCP 套接字不被关联到任何一个用户文件句柄上
net.ipv4.tcp_max_orphans = 131072

# 启用 TIME_WAIT 复用，使得结束 TIEM_WAIT 状态的套接字的端口可以立刻被其他套接字使用。
# 关闭 tcp timestamp, 和 tw_reuse/tw_recycle，RFC1323里面，TCP_TW_RECYCLE和TCP的timestamp选项（timestamp系统默认开启）同时生效的时候，在NAT场景下会导致服务器无法响应连接，这个也是可以复现的。
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_tw_buckets = 7000

# 优化 nf_conntrack 参数，防止服务器出现大量短链接的时候出现丢包
net.netfilter.nf_conntrack_max=1048576
net.nf_conntrack_max=1048576
net.netfilter.nf_conntrack_tcp_timeout_fin_wait=30
net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
net.netfilter.nf_conntrack_tcp_timeout_close_wait=15
net.netfilter.nf_conntrack_tcp_timeout_established=300

# 缩短套接字处于 TIME_WAIT 的时间， 60s -> 15s
net.ipv4.tcp_fin_timeout = 15
# 减小 tcp keepalive 探测次数，可以即时释放长链接
net.ipv4.tcp_keepalive_probes = 3
# 缩短 tcp keepalive 探测间隔时间，同上
net.ipv4.tcp_keepalive_intvl = 15
# 修改 tcp keepalive 默认超时时间
net.ipv4.tcp_keepalive_time = 7200

# 关闭慢启动重启(Slow-Start Restart), SSR 对于会出现突发空闲的长周期 TLS 连接有很大的负面影响
net.ipv4.tcp_slow_start_after_idle = 0
# 启用 MTU 探测，在链路上存在 ICMP 黑洞时候有用（大多数情况是这样）
net.ipv4.tcp_mtu_probing = 1
# 打开内核的 SYN Cookie 功能，可以防止部分 DOS 攻击。
net.ipv4.tcp_syncookies = 1
# 当某个节点可用内存不足时, 系统会倾向于从其他节点分配内存。对 Mongo/Redis 类 cache 服务器友好
vm.zone_reclaim_mode = 0
# 当内存使用率不足10%（默认值60%）时使用 swap，尽量避免使用 swap，减少唤醒软中断进程
vm.swappiness = 10
# 内核执行无内存过量使用处理。使用这个设置会增大内存超载的可能性，但也可以增强大量使用内存任务 Mongo/Redis 的性能。
vm.overcommit_memory = 1

# 指定 fair queue 算法, 为了配合 google bbr 算法
#net.core.default_qdisc = fq
# 使用 google bbr 拥塞控制算法。
#net.ipv4.tcp_congestion_control = bbr

# 启用 tcp fast open
# net.ipv4.tcp_fastopen = 3

# 禁用 ipv6
# net.ipv6.conf.all.disable_ipv6 = 1
# net.ipv6.conf.default.disable_ipv6 = 1
# net.ipv6.conf.lo.disable_ipv6 = 1

# 以下参数和系统具体物理内存大小有关，最好查询文档以后配置最佳值
#net.core.wmem_default = 262144
#net.core.rmem_max = 16777216
#net.core.wmem_max = 16777216
#net.ipv4.tcp_rmem = 4096 4096 16777216
#net.ipv4.tcp_wmem = 4096 4096 16777216
#net.ipv4.tcp_mem = 786432 2097152 3145728

# 增加初始拥塞窗口和滑动窗口，提高 Proxy 业务性能
# see https://www.cdnplanet.com/blog/initcwnd-settings-major-cdn-providers/
# sudo ip route change $(ip route show|grep '^default'|head -1) initcwnd 10 initrwnd 25

# 增加当前服务器进程的文件打开数目，解决 too many open files 错误
# sudo ss -anptl | grep -oP 'pid=\K[0-9]+' | xargs -n1 -i sudo prlimit --pid {} --nofile=1048576

# 永久增加文件打开数目，解决 too many open files 错误，需要重启系统生效
# curl https://phuslu.github.io/sysctl.conf | sudo tee /etc/sysctl.d/10-phuslu.conf && echo -e "* soft nofile 1048576\n* hard nofile 1048576" | sudo tee /etc/security/limits.d/99-phuslu.conf && sudo sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
```
