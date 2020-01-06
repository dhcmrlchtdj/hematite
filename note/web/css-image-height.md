# image height

---

http://zihua.li/2013/12/keep-height-relevant-to-width-using-css/

---

如何设置图片的宽高比例，不受图片本身的比例限制。

上文提到一种方法
利用 padding 来代替 height/width，然后 width/height 本身设置为 0。
padding 在百分比时是根据父元素来的，可以实现根据父元素进行缩放。
不需要父元素相关也可以直接固定，比例完全可以自己控制，做到和图片本身无关。
