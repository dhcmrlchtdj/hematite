# leet code database

https://oj.leetcode.com/problemset/database/

---

## 2015-02-14

+ 需要补 mysql 语法，特别是自定义变量的使用。
+ 脑袋不够灵活……

---

### 183

本质上，是取 Customers 对 Orders 的补集。
除了 `not in` 子查询，还可以用 `outer join`。

+ http://coolshell.cn/articles/3463.html

---

### 182

找出表中重复纪录，可以用 `group by` + `having`。

---

### 175

简单的两表求并集。

---

### 181

简单自交。

---

### 176, 177

嵌套 `max` 子查询是一种思路，但不通用。

感觉排序后 `limit offset` 更好些，然后踩了重复元素的坑，需要 `distinct` 辅助。

最坑的是必须返回 `null` 及函数语法。

---

### 184, 185

+ http://www.xaprb.com/blog/2006/12/07/how-to-select-the-firstleastmax-row-per-group-in-sql/

对内容进行分组，进行筛选后聚合结果。
思路不难，但用 sql 表达，对我这种新手就比较复杂了。

---

### 180

自交。

---

### 178

坑的是只支持单个语句……定义变量时老是报错。
