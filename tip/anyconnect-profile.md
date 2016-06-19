# AnyConnect profile

---

http://superuser.com/questions/932650/cisco-anyconnect-secure-mobility-client-multiple-profiles
https://supportforums.cisco.com/document/12549161/anyconnect-xml-preferences
http://www.cisco.com/c/en/us/td/docs/security/vpn_client/anyconnect/anyconnect40/administration/guide/b_AnyConnect_Administrator_Guide_4-0/anyconnect-profile-editor.html
http://www.cisco.com/c/en/us/td/docs/security/vpn_client/anyconnect/anyconnect40/administration/guide/b_AnyConnect_Administrator_Guide_4-0/configure-vpn.html

---

为何手机端就有完整的选项，PC 上要自己写配置文件，还没好的文档……
简单的服务器切换，用下面这样的设置就行。v4.2 测试可用

```
$ cat /opt/cisco/anyconnect/profile/Profile.xml
<AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/">
	<ServerList>
		<HostEntry>
			<HostName>cisco A</HostName>
			<HostAddress>https://www.cisco.com</HostAddress>
		</HostEntry>
		<HostEntry>
			<HostName>cisco B</HostName>
			<HostAddress>https://www.cisco.com</HostAddress>
		</HostEntry>
	</ServerList>
</AnyConnectProfile>
```
