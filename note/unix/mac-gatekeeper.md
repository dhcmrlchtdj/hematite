# mac gatekeeper

homebrew 安装了 graalvm，怎么都打不开…

网上找了一圈 `sudo xattr -r -d com.apple.quarantine /Library/Java/JavaVirtualMachines/graalvm-ce-java11-19.3.0` 解决
