# jenkins slave

https://stackoverflow.com/questions/38724448/creating-a-jenkins-slave-via-java-web-start/38740924#38740924
https://wiki.jenkins.io/display/JENKINS/Distributed+builds
https://note.qidong.name/2019/01/jenkins-jnlp-agent/

又不让用外部服务，内部又没有好的服务。比较尴尬，只能自己搞。
由于安全问题，又不能直接用 ssh 的方式启动 slave，只能选择 JNLP 的方式。

第一步是要在 master 开启端口。
`Manage Jenkins => Configure Global Security => Enable security => TCP port for JNLP agents Set it to either Fixed (for this option also set the port number) or Random.`
这样创建 slave 时才会出现 JNLP 的选项。

第二步是在 slave 上搭建 JNLP 的环境。
需要从 master 下载一个 agent.jar。
在 jenkins 网页上，进入 slave 节点详情，会提示该如何启动 agent.jar。
然后把启动命令搞成开机自动启动即可。
