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

---

更新个 10.12 的情况

|            | zh-Hans             | zh-Hant             | ja                                | en             |
| -          | -                   | -                   | -                                 | -              |
| serif      | STSongti-SC-Regular | STSongti-TC-Regular | HiraMinProN-W3                    | Times-Roman    |
| sans-serif | PingFangSC-Regular  | PingFangTC-Regular  | HiraginoSans-W3/HiraginoSansGB-W3 | LucidaGrande   |
| monospace  | PingFangSC-Regular  | PingFangTC-Regular  | HiraginoSans-W3/HiraginoSansGB-W3 | Monaco         |
| cursive    | STSongti-SC-Regular | STSongti-TC-Regular | HiraMinProN-W3                    | Apple-Chancery |
| fantasy    | STSongti-SC-Regular | STSongti-TC-Regular | HiraMinProN-W3                    | Zapfino        |

日语英语都没变化，中文把楷体换成了宋体
