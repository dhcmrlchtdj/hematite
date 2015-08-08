# eliminate

---

## tl;dr

核心就是将需要消除的部分隔离开。

---

## eliminate epsilon

假设有

```
A -> x | esp
B -> yAz
```

可以将 `A` 拆解为 `C -> x` 和 `D -> esp`，带入 `B` 可得到

```
C -> x
D -> esp
B -> yCz | yDz
```

简化下就能的到

```
C -> x
B -> yCz | yz
```

关键就是将 `A` 中的需要消去 `esp` 和其他值分开。

---

## eliminate direct left recursion

首先来个死记硬背

```
A -> Ax | y
```

可以转化成

```
A -> yB
B -> xB | esp
```

再消除下 `esp` 会有

```
A -> y | yC
C -> x | xC
```

理解就是 `A` 中非左递归的有 `A -> y`，剩下的是只会左递归的 `A -> Ax`。
只会左递归的部分在递归多次后是 `Axxxx...`，加上非左递归部分就是 `yxxxxxxx...`。
将右边的 `x` 改写成右递归形式 `C -> x | xC`，也就是 `A -> yC`。
加上 `A -> y` 就有了上面的结果。

---

## eliminate indirect left recursion

对于间接左递归，直接代入得到直接左递归，再用前面的做法，把直接左递归一个个消去。

如

```
A -> Bx | y
B -> Cm | n
C -> Ap | q
```

可化为

```
A -> Apmx | qmx | nx | y
B -> Apm | qm | n
C -> Ap | q
```

处理 `A` 后可得

```
D -> qmx | nx | y
E -> pmxE | pmx
A -> D | DE
```

代回 `A` 可得

```
D -> qmx | nx | y
E -> pmx | pmxE
A -> D | DE
B -> Dpm | DEpm | qm | n
C -> Dp | DEp | q
```
