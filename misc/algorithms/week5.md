2-3 tree
- allow 1/2 keys per node
    - one key, two children
        - left, samller
        - right, larger
    - two key, three children
        - left, smaller
        - middle, between
        - right, larger
- inorder traversal yield keys in ascending order
- search, just like BST
- insertion
    - 2-node，如果要插入的节点是 one key
        - 直接转换成 two key
    - 3-node，如果要插入的节点已经 two key
        - 先插入当前节点，变成 three key
        - 把 3 个 key 里中间那个 key 给父节点
            （即把父节点变成 two key，如果父节点本身就是 two key，重复本过程
        - 剩下的两个 key 拆开变成两个 one key 的节点
- perfect balance, every path from root to null link has same length
- direct implementation is complicated
    - large number of cases for splitting

---

red-black BST
- left-leaning red-black BST
    - 节点和其红边相连的节点，可以合起来视为 2-3 tree 中的 two-key node
- search, same as BST
- representation
    - special property, color of parent link
- left rotation / right rotation / color flip
- 保持 left-leaning
    - 只有右子节点红了，就 left rotation 一下
    - 左子节点和左孙子节点都红了，right rotation 一下
    - 左右子节点都红了，color flip 一下
- same code for all cases

---

b-tree
- generalize 2-3 trees by allowing up to M-1 key-link pairs per node
