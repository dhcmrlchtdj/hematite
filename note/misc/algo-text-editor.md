# text editor

https://zhuanlan.zhihu.com/p/37771748
https://zhuanlan.zhihu.com/p/46693881

https://www.averylaird.com/programming/the%20text%20editor/2017/09/30/the-piece-table/
https://www.averylaird.com/programming/piece-table/2018/05/10/insertions-piece-table/

how to store and manipulate text?

- the worst way: array
- a good way: rope (binary tree)
- a better way: gap buffer (dynamic array)
- the best way: piece table

---

https://en.wikipedia.org/wiki/Rope_(data_structure)

```ocaml
type rope =
  | Leaf of { len : int; str : string }
  | NonLeaf of { left_len : int; left : rope option; right : rope option }

let split (s : rope) (idx : int) : rope * rope = failwith "TODO"
let concat (a : rope) (b : rope) : rope = failwith "TODO"
```

- 结构
    - 叶子节点，包含字符串的内容（及长度）
    - 中间节点，包含左子节点的长度
- 在 idx 位置进行操作，可以根据 left_len 判断向左还是向右
- 使用 split/concat 可以完成 insert/delete 等操作
- 文章作者说 using a rope is quite confusing and complicated，我倒是没感觉…

---

https://en.wikipedia.org/wiki/Gap_buffer

- wiki 上也没有图，我是觉得不太直观…
- 例子都是完全针对编辑器的 insert/delete 操作的
- 大概是说，在 cursor 处留出 buffer
    - insert 直接填充 buffer，直到 buffer 用完之前，都不会影响前后的原字符串
    - delete 直接修改前面的字符串，buffer 变大，不影响后面的字符串

---

https://en.wikipedia.org/wiki/Piece_table

```ocaml
type item = { which : [ `Original | `Add ]; start : int; len : int }
type s = { original : string; add : string; piece_table : item list }
```

- 两个 buffer，read-only 的 original 和 append-only 的 add
- 字符串是由这两个底层结构，加上一个 table 组成的
    - 从 original 读取几个字符，再从 add 读取几个字符，交替，组成需要的字符串
- delete 操作直接操作 piece table 即可
- insert 需要将新字符插入 add，然后更新 piece table，可能需要把原来的 item 拆开
