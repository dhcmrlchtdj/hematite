+ 查看有哪些数据库  
    `SHOW DATABASES;`

+ 使用数据库  
    `USE db_name`

+ 当前使用的数据库  
    `SELECT DATABASE();`

+ 查看有哪些表  
    `SHOW TABLES;`

+ 查看表结构  
    `DESC tb_name;`

+ 权限  
    `grant all on db.table to 'name'@'host'`


-------------------------------------------------------------------------------

# Language Structure

## string
+ binary string
    下面三个写法等价
    - `"example"`
    - `'example'`
    - `"exam" 'ple'` -- space is ignore

+ nonbinary string
    下面两个写法等价
    - `_utf8"text"`
    - `n'text'` -- must use single quote

+ escape
    下面三个写法等价，都是一个双引号
    - `'"'`
    - `"\""`
    - `""""`


## number
+ 1
+ 0
+ \-1
+ 1.1
+ \-1.1
+ 1e+10


## date and time
分割符（-）无所谓，统一就行（-^#$)，没有也行。
非法的时间信息会变成相应格式的 0（比如月份大于12）。

+ yyyy-mm-dd hh:mm:ss
+ yy-mm-dd hh:mm:ss

+ yyyy-mm-dd
+ yy-mm-dd

+ d hh:mm:ss.fraction -- d represents days, can have value from 0 to 34.
+ hh:mm:ss.fraction
+ hh:mm:ss
+ hh:mm
+ mm:ss
+ hh
+ ss


## hexadecimal
下面三种写法等价。  
注：用 x'' 这种写法，必须要有偶数个数字。

+ `0x0`
+ `x'00'`
+ `X'00'`

可以用这两个函数转换

+ `CAST(0x61 AS UNSIGNED)` => `65`
+ `HEX('a')` => `61`


## boolean
大小写无所谓。

+ `true` = 1
+ `false` = 0


## bit
下面两种写法等价。

+ `b'1'`
+ `0b1`

使用时，会被当作二进制字符串。  
可以用`CAST(bit AS UNSIGNED)`或者`bit+0`的方式转换成数字。


## NULL
下面两种写法等价，第二种必须是大写。

+ NULL
+ \N


## 保留字
为了避免列名和保留字冲突，可以用\`（backtick）把列名包起来，就像`col_name`。


## 变量
`SET @v1 = expr1, @v2 := expr2, @v3 := @v1;`  
字面量可以混用`=`和`:=`，变量间为了和比较分开，必须用`:=`。  
干脆只用`:=`吧。





