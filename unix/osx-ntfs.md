# osx ntfs

---

+ http://osxdaily.com/2013/10/02/enable-ntfs-write-support-mac-os-x/
+ https://github.com/noma4i/NativeNTFS-OSX

---

```bash
wntfs () {
    uuid=$(diskutil info "$1" | grep UUID | cut -d ':' -f2 | tr -d ' ')
    volumeName=$(diskutil info "$1" | grep "Volume Name" | cut -d ':' -f2 | tr -d ' ')
    if [ "$uuid" = "" ]; then
        line="LABEL=$volumeName none ntfs rw,auto,nobrowse";
    else
        line="UUID=$uuid none ntfs rw,auto,nobrowse";
    fi
    echo $line >> /etc/fstab
    device=$(diskutil info "$1" | grep "Device Node" | cut -d ':' -f2 | tr -d ' ')
    diskutil unmount "$1"
    diskutil mount $device
}
```
