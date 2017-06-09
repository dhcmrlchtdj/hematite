# swift sdk

---

http://stackoverflow.com/questions/13964742/sdkroot-path-for-latest-sdk

---

如果代码里引入了 `Foundation`，在使用 `swiftc` 编译时会提示找不到 SDK。

```
$ swiftc -parse filename.swift
<unknown>:0: error: cannot load underlying module for 'CoreGraphics'
<unknown>:0: note: did you forget to set an SDK using -sdk or SDKROOT?
<unknown>:0: note: use "xcrun -sdk macosx swiftc" to select the default OS X SDK installed with Xcode
```

直接按照提示 `xcrun -sdk macosx` 当然是可以的。
但是我是想要搞 vim 的语法检查呀，所以还是找了下 SDKROOT。

---

```
$ xcodebuild -version -sdk # 列出所有可用的 SDK
$ xcodebuild -version -sdk macosx # 具体的某个SDK，比如上面提示的 macosx

MacOSX10.11.sdk - OS X 10.11 (macosx10.11)
SDKVersion: 10.11
Path: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
PlatformVersion: 1.1
PlatformPath: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform
ProductBuildVersion: 15E60
ProductCopyright: 1983-2016 Apple Inc.
ProductName: Mac OS X
ProductUserVisibleVersion: 10.11.4
ProductVersion: 10.11.4

$ xcodebuild -version -sdk macosx Path # 还可以只输出 path，这个就是 SDKROOT 了
```

所以

```
$ SDKROOT=macosx10.11 swiftc -parse filename.swift
$ SDKROOT=$(xcodebuild -version -sdk macosx Path) swiftc -parse filename.swift
```
