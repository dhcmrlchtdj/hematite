+ http://www.w3.org/TR/CSS2/visuren.html
+ https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Visual_formatting_model

---

## containing block

+ root 形成了最早的容器
+ `position:fixed` 的容器边界为 viewport
+ `position:static|relative` 的容器边界为最近的块级祖先的 content edge
+ `position:absolute` 的容器边界为最近的已定位祖先的 padding edge
    - 标准里把祖先为行类元素的情况单独拿出来讲，不过通常情况下，理解为 padding edge 够用了

---

## box

+ 页面中的元素有 element 和 box 之分。
+ 页面中的元素有 block 和 inline 之分。

---

### block

+ block-level element
    - display: block|table|list-item

+ block-level box
    - block formatting context 中的 box
    - 每个 block-level element 都会生成一个 principle block-level box

+ block container box
    - 内部只有 block-level box 或者只有 inline-level box
    - table 和 replaced element 虽然是 block-level box，但不是 block container box
    - 其他的 block-level box 都是 block container box
    - 除了 block-level box，还有像 inline-block 也是 block container

+ block box
    - 既是 block-level box 又是 block container

---

### inline

+ inline-level element
    - display: inline|inline-block|inline-table

+ inline-level box
    - inline formatting context 中的 box
    - inline-level element 会生成 inline-level box

+ inline box
    - non-replaced element 且 display:inline 会生成 inline boxes

+ atomic inline-level boxes
    - 不是 inline box 的 inline-level box
    - 比如 inline-block 和 inline-table
    - 比如 replaced element
    - 这些元素对周围来说是一个不可见的整体

---

## position scheme

+ normal flow
+ float
+ absolute positioning

---

### normal flow

+ normal flow 包括 block formatting 和 inline formatting 和 relative positioning

---

#### block formatting context

+ 以下情况会为内部建立一个新的 BFC
    - 浮动 float
    - 绝对定位的元素 absolutely positioned element
    - block boxes 除外的 block container
    - overflow 不是 visible 的 block boxes
    - 根据 MDN，flex 和 inline-flex 也会
+ BFC 内
    - 元素垂直排列
    - 元素会发生外边距叠加
    - 元素的左 margin edge 在容器的左边界上

---

#### inline formatting context

+ 在 IFC 内
    - 元素水平排列
+ IFC 中的行，称为 line box
    - inline box 的宽度超过 line box 的时候，会换行，分散在多个 line box 中
    - vertical-align 和 text-align 作用于 line box 的内容

---

#### relative positioning

+ 当 left right 发生冲突时，根据`父元素`的 direction 来决定使用哪个
+ 当 top bottom 发生冲突时，使用 top

---

### float

+ clear 的实质
    + 对于非浮动的元素，让元素的 top border edge 在浮动元素的 bottom margin edge 之下
    + 对于浮动的元素，让元素的 top margin edge 在前面元素的 bottom margin edge 之下

---

### absolute positioning

+ absolute 和 fixed
+ top/right/bottom/left 本质是对应的 margin edge 与容器边界的距离
+ 当 top/bottom 发生冲突时
    - 如果元素高度固定，会忽略 bottom
    - 如果元素高度不定，会对应的 margin edge
+ left/right 同理，忽略哪个由父元素的 direction 决定
    - 但是，在自身也设置了 direction 的情况下，看不懂

---

## 顺序

+ display:none
+ position:absolute|fixed
+ float:left|right
+ diplay:xxx
