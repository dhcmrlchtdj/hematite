# z-index
+ https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Understanding_z_index
+ http://www.w3.org/TR/CSS21/visuren.html#z-index

#### 效果
+ z-index 实际上有两种效果
+ 一是在元素（box）当前栈（stacking context）内的高度（stack level）
+ 二是创建一个新的栈（stacking context）

#### 取值
+ 数字，auto，inherit
+ 默认是 auto，不可继承
+ auto 意味着在当前栈的高度为 0，且不会创建新的栈。root 是个例外，创建了起始栈
+ 可以用数字指定元素在当前栈的高度，这种情况下会创建新的栈
+ auto 与 0 的区别在于是否创建新的栈
+ 也不是设置了 z-index 就会创建新的栈，具体往下看

#### 栈中元素的绘制顺序
1. background 和 border
2. 高度（stack level）为负值的子栈（child stacking context），从值最小的开始
3. in-flow, non-inline-level, non-positioned，也就是处在文档流中的块级元素
4. non-positioned floats，也就是浮动元素
5. in-flow, inline-level, non-positioned，也就是处在文档流中的行内元素
6. 高度为 0 的子栈 和 高度为 0 的定位元素
7. 高度为正值的子栈，还是从值最小的开始

+ 这个绘制顺序，会被递归用于页面中的每个栈。
+ 每个元素都属于某个栈
+ 栈中元素的 z-index 的不与栈外元素比较
+ stacking context 和 containing block 没有必然联系

#### 什么时候会创建出新的栈
+ root，也就是根元素，创建了最早的栈
+ `position: [absolute|relative]` 加上 `z-index: <int>`
+ `display: flex` 加上 `z-index: <int>`
+ `opacity: <1`
+ `position: fixed`
+ 查最新资料
