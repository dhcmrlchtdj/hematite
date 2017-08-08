# tree data

---

https://typeorm.github.io/tables-and-columns.html#tree-tables

---

## Adjacency list

- Adjacency list is a simple model with self-referencing.
- Benefit of this approach is simplicity,
- drawback is that you can't load big tree an once because of joins limitation.

---

```javascript
@Entity()
export class Category {
    @PrimaryGeneratedColumn()
    id: number;
    @Column()
    name: string;
    @Column()
    description: string;
    @OneToMany(type => Category, category => category.children)
    parent: Category;
    @ManyToOne(type => Category, category => category.parent)
    children: Category;
}
```

---

## Closure table

- Closure table stores relations between parent and child in a separate table in a special way.
- Its efficient in both reads and writes.

---

```javascript
@ClosureEntity()
export class Category {
    @PrimaryGeneratedColumn()
    id: number;
    @Column()
    name: string;
    @Column()
    description: string;
    @TreeChildren({ cascadeAll: true })
    children: Category;
    @TreeParent()
    parent: Category;
    @TreeLevelColumn()
    level: number;
}
```

---

https://www.slideshare.net/billkarwin/models-for-hierarchical-data

---

典型的就是评论，树形的结构。

---

- adjacency list
    - each entry knows its immediate parent
    - `{id=3, parent_id=1}`
    - 需要进行遍历才能把整棵树构造出来（SQL-99 recursive)
- path enumeration
    - store chain of ancestors in each node
    - `{id=4, path=1/3/4}`
    - 感觉像是把复杂度平摊了一样……
- nested sets
    - 感觉就是平衡树？插入的复杂度太高了，查询还没有很大的优势
- closure table
    - stores every path from each node to each of its descendants
    - 额外维护一张关系表，每个节点都知道自己全部子节点
    - （O(n^2) 的空间开销，不过 slide 里说实践证明开销不大（毕竟只有 id
    - 还是平摊的思路，空间换时间

---

- 简单到只有一层的情况，adjacency list 就可以了
- 复杂一点的情况，可以考虑 path enumeration 或者 closure table
    - path enumeration 查找直接子节点稍微麻烦
    - closure table 需要两张表

---

https://stackoverflow.com/questions/4048151/what-are-the-options-for-storing-hierarchical-data-in-a-relational-database

---
