# mac default font

---

https://www.zhihu.com/question/19693837

---

```
$ open /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreText.framework/Resources/DefaultFontFallbacks.plist
```

---

在 10.11.2 下面，大概是这样

|            | zh-Hans             | zh-Hant             | ja              | en             |
| -          | -                   | -                   | -               | -              |
| serif      | STSongti-SC-Regular | STSongti-TC-Regular | HiraMinProN-W3  | Times-Roman    |
| sans-serif | PingFangSC-Regular  | PingFangTC-Regular  | HiraginoSans-W3 | LucidaGrande   |
| monospace  | PingFangSC-Regular  | PingFangTC-Regular  | HiraginoSans-W3 | Monoca         |
| cursive    | STKaiti-SC-Regular  | STKaiti-TC-Regular  | HiraMinProN-W3  | Apple-Chancery |
| fantasy    | STKaiti-SC-Regular  | STKaiti-TC-Regular  | HiraMinProN-W3  | Zapfino        |
