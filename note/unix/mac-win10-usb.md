# win10 usb

https://www.freecodecamp.org/news/how-make-a-windows-10-usb-using-your-mac-build-a-bootable-iso-from-your-macs-terminal/

- 下载 win10 <https://www.microsoft.com/zh-cn/software-download/windows10ISO>
- `diskutil list` 找到 usb，比如 `/dev/disk2`
- 格式化 usb `diskutil eraseDisk MS-DOS "WIN10" GPT /dev/disk2` 或者 `diskutil eraseDisk MS-DOS "WIN10" MBR /dev/disk2`
- 挂载 win10 `hdiutil mount ~/Downloads/win10.iso`
- 复制 `cp -rp /Volumes/CCXXX_DV9/* /Volumes/WIN10/`
