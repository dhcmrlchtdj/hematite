# vuex

大部分场景下，可以自动生成配套的 getter/mutation，能够很大程度降低 vuex 的使用成本
但在表单、表格的处理上，双向绑定加上 v-model 要方便很多

双向绑定，直接修改变量即可；mutation 需要定位到数据的位置，再对数据进行赋值
在数据嵌套比较多的情况下，差异就非常明显了

## 问题

比较复杂的表单，选项经常相互关联。使用双向绑定，必然要使用 watch 来触发修改
个人认为 watch 这样的自动触发机制是万恶之源
数据走入了 data -> watch -> data -> watch 的死循环

而在 vuex 的限制下，数据修改要经过 mutation
关联的修改，在 mutation 时触发其他 mutation 就可以了

就数据修改来说，我是支持 mutation -> state 反对 data -> watch 的

## 方案

要么在 getter/mutation 的基础上，优化对复杂表单、表格的支持
要么在双向绑定的基础上，解决 watch 的循环问题
目标还是优化 mutation，但是没想好要怎么做
