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

μ = mean(X)
σ^2 = sum(Xi - μ) / len(X)
σ = sqrt(σ^2)

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

---
## binomial experiment
二项式过程？

满足三个条件
+ n 次重复实验
+ 每次实验都是独立的
+ 每次实验的结果都只有 成功／失败 两种情况


### PMF(probability mass function)，概率质量函数
离散随机变量的值

比如上面那个 二项过程 的 概率质量函数 是
f(x) = (p^x) * ((1-p)^(1-x)), 其中 x={0,1}
0 表示失败，1 表示成功
也可以写成 f(0) = 1-p, f(1) = p
这里 p 是成功的概率


## binomial distribution
二项分布

定义
+ n 次实验
+ x 次成功
+ 成功的概率为 p
+ 失败的概率为 q = 1 - p
+ b(x,n,p) 表示每次实验成功的概率 p，进行 n 次实验，成功 x 次的概率

b(x,n,p) 叫做 binomial probability，二项概率？
b(x,n,p) = nCx * p^x * q^(n-x)


## cumulative probability
累积概率

累积分布函数（CDF, cumulative distribution function），`Fx(a) = P(X <= a)`
`P(a < X <= b) = Fx(b) - Fx(a)`

---

## negative binomial experiment
负二项实验

还是前面的 二项实验，加上一个条件
第 x 次成功后，终止了实验

b*(x,n,p) = (n-1)C(x-1) * p^x * q^(n-x)
其实公式和前面很接近，理解起来其实就是
前面 n-1 次实验，成功了 x-1 次，
再进行第 n 次实验，然后这个第 n 次成功了，即此时成功了 x 次
这种情况的概率就是 b*

b*(x,n,p) = b(x-1,n-1,p) * p
	= (n-1)C(x-1) * p^(x-1) * q^(n-1 - (x-1)) * p
	= (n-1)C(x-1) * p^x * q^(n-x)


## geometric distribution
几何分布

成功次数为 1 的 negative binomial distribution

g(n,p) = q^(n-1) * p

---

## poisson distribution
泊松分布

柏松实验的特点
+ 结果只有 成功／失败 两种情况
+ 某个区间内的平均成功概率已知
+ 成功概率与区间成比例
+ 区间极小时，成功概率趋近于 0


P(k,λ) = (λ^k * e^-λ) / k!
e = 2.718
λ 为平均成功次数
k 为实际成功次数
P(k,λ) 为平均成功次数为 λ 时，成功 k 次的概率

和二项分布一样，是可以叠加哒


变量 X 满足柏松分布，则
期望 E(X) = λ
方差 VAR(X) = λ
则 VAR(X) = E(X^2) - E(X)^2
=> E(X^2) = VAR(X) + E(X)^2
	= λ + λ^2

---

## normal distribution
正态分布

N(μ,σ^2) = (1 / (σ * sqrt(2 * pi))) * (e ^ (- (x-μ)^2 / 2σ^2))
μ 平均数，同时也是正态分布的中位数和众数
σ 方差

当 μ=0,σ=1 时，有 标准正态分布
ϕ(x) = (e * (- x^2/2)) / sqrt(2 * pi)

正态分布都可以用标准正态分布表示
N(μ,σ^2) = 1/σ * ϕ((x-μ) / σ)

正态分布的累积分布概率
O(x) = (1 + erf((x-μ) / (σ * sqrt(2)))) / 2
erf(z) = ...
