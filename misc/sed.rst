::

    # 打印第 10 行
    # -n 关闭输出
    $ sed -n "10p" filename

    # 删除 1 到 10 行
    # -i 修改源文件
    $ sed -i "1,10d" filename

    # 1 到 10 行的 a 替换为 b
    # -i[suffix] 修改并备份源文件
    $ sed -i.bk "1,10s/a/b/" filename


    # 地址写法

    $ sed -n "10p" filename     # 第 10 行
    $ sed -n "10,20p" filename  # 10 到 20 行
    $ sed -n "/p1/, /p2/p" filename     # 模式 1 到 模式 2
    $ sed -n "/p1/, +10p" filename  # 模式 1 及接下来 10 行 （共 11 行）
    $ sed -n "0~1p" filename    # 从 0 行开始，隔 1 行输出一次 （就是全文了）
    $ sed -n "1~5p" filename    # 第一行起，每 5 行输出一次

    $ sed -r '/a.*?a/p' filename    # 使用拓展的正则
