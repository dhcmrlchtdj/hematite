# statistics / hacker rank

---

## mean / mediam / mode
平均数 / 中位数 / 众数

还真不知道众数这么翻译的

---

## weighted mean
加权平均数

---

## quartile
四分位数，不认识的词真多

Q1/Q2/Q3
对半分，Q1 是左半边的中位数，Q3 是右半边的中位数，Q2 是整个序列的中位数

---

## interquartile range
四分位距，IQR，即 (Q3 - Q1)
好像见过，但是完全没印象了

---

## standard deviation / variance / expected values
标准差，这个能认出来……

python 库里有 population standard deviation 和 sample standard deviation
又是只有模糊印象的概念
数学不练真得就都还给老师了……

期望／方差／标准差

u = mean(X)
o^2 = sum(Xi - u) / len(X)
o = sqrt(o^2)

---

## probability

事件 A，样本空间 S，概率 P(A)，P(S)

+ 独立事件 A 和 B，有 P(A and B) = P(A) * P(B)
+ A B 互斥时，P(A or B) = P(A) + P(B)

---

## conditional probability
条件概率
AB 没有交集时，P(B|A) = P(B)
AB 存在交集时，P(B|A) = P(A∩B) / P(A)

## Bayes' Theorem
贝叶斯定理
P(A|B) = (P(B|A) * P(A)) / P(B)
	= (P(B|A)*P(A)) / (P(B|A)*P(A) + P(B|A')*P(A'))

(B 发生的情况下，A 发生的概率)
	= ((A 发生的情况下，B 发生的概率) * (A 发生的概率)) / (B 发生的概率)
	= (A B 同时发生的概率) / (B 发生的概率)

---

## permutations && combinations
排列 && 组合
排列是有序的，组合是无序的

n 取 r 的排列数 nPr = n! / (n-r)!
n 取 r 的组合数 nCr = nPr / r! = n! / (r! * (n-r)!)
