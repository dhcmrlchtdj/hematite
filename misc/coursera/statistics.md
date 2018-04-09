# statistics

---

- sample - statistics
- population - parameter

---

- random selection
- random assignment

---

- correlation research

- big five personality traits / five factor model
    - openness to experience, 开放性
        - inventive / curious VS consistent / cautious
    - conscientiousness, 尽责性
        - efficient / organized VS easy-going / careless
    - extraversion, 外向性
        - outgoing / energetic VS solitary / reserved
    - agreeableness, 宜人性
        - friendly / compassionate VS challenging / detached
    - neuroticism, 情绪不稳定性
        - sensitive / nervous VS secure / confident
    - 五低 🙄️
        - 低开放性
        - 低尽责性
        - 低外向性
        - 低宜人性
        - 低情绪不稳定性
- Cattell–Horn–Carroll theory
    - 理解
    - 推理
    - 数量
    - 阅读写作
    - 短期记忆
    - 长期记忆、检索
    - 视觉处理能力
    - 听觉处理能力
    - 处理速度

---

- types of variable
    - nominal，类别，比如国家
    - ordinal，可排序，比如国家的人口
    - interval，有固定间隔，比如经纬度
    - ratio，0 有意义（不太懂），比如人口、时间
- 不同的类型，能进行的操作不同；从上往下，可以进行的操作越来越多
    - 是否相同
    - 比较大小
    - 大小计算
    - ?
- discreet / continous

---

- histograms
    - normal distribution
    - position/negative skew
- scale of measurement
    - z score
        - Z = (X - M) / SD
        - X is the raw score
        - M is the mean
        - SD is the standard deviation
    - percentile rank
    - raw score ~ z-score ~ percentile rank

---

- measure of central tendency (the middle or center point of a distribution)
    - mean: the average, `M = (\sum X) / N`
    - median: the middle score
    - mode: the score that occurs most often

- mean is the best measure of central tendency when the distribution is normal
- median is preferred when there are extreme scores in the distribution

---

- measure of variability (the range and diversity of scores in a distribution)
    - standard deviation (SD)
        - `SD = \sqrt \frac {\sum (X-M)^2} {N}`
    - variance = SD^2
        - `VAR = \frac {\sum (X-M)^2} {N}`
        - MS (mean squares)
            - SS (sum of squares)
            - MS = SS/N = SD^2

- formulae
    - `M = \frac {\sum X} {N}`
    - `VAR = \frac {\sum (X-M)^2} {N}`
        - descriptive statistics
    - `VAR = \frac {\sum (X-M)^2} {N-1}`
        - inferential statistics

---

- correlation
    - measure and describe the relationship between two variables
    - range `+1 / 0 / -1`, 0 means independence
    - (if correlated) one variable can be used to predict the other variable
- caution
    - correlation does not imply causation
    - the magnitude of a correlation depends upon many factors
    - the correlation coefficient is a sample statistic, just like the mean
- types of correlation coefficients
    - pearson product-moment correlation coefficient (r)
    - phi coefficient
    - ...

---

- correlation is standardized COV
- r, pearson product-moment correlation coefficient
    - raw score
        - `r = \frac {SP_{xy}} {\sqrt {SS_x * SS_y}}`
        - `r = \frac {\sum [(X-M_x)*(Y-M_y)]} {\sqrt {\sum(X-M_x)^2 * \sum(Y-M_y)^2}}`
    - Z-score
        - `r = \frac {Z_x * Z_y} {N}`
        - `r = \frac {{\frac {X-M_x} {SD_x}} * {\frac {X-M_y} {SD_y}}} {N}`
- variance = MS = SS/N
- covariance = COV = SP/N
    - divide by N for descriptive
    - divide by N-1 for inferential

---

- assumptions when interpreting r
    - normal distributions for X and Y
    - linear relationship between X and Y
    - homoscedasticity 🙄️

---

- measurement
    - reliability
        - raw score = true score + bias + error
        - estimate reliability
            - test / re-test
            - parallel tests
            - inter-item estimates
    - validity
        - construct validity
            - content validity
            - convergent validity
            - divergent validity
            - nomological validity
    - sampling
        - sampling error: the difference between the population and the sample
            - estimate sampling error
                - increase the size of the sample
                - decrease variance
        - standard error: an estimate of amount of sampling error
            - StandardError = StandardDeviationOfSample / SQRT(Size)
