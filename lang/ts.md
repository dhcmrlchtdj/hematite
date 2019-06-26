# TypeScript

- 对照 https://github.com/Microsoft/TypeScript/wiki/Architectural-Overview
- 关键代码都在 compiler 下面
- core 是辅助函数，略过
- emitter 是输出代码，略过
- scanner/parser 没有用生成器，都是手写的
- scanner 靠 look ahead 判断是什么 token，搜了下代码，最多也只需要向前看两个符号即可
- parser 驱动 scanner，而不是直接生成 token 列表
- parser 使用了 recursive descent 进行解析
- parser 处理优先级时，使用了 precedence climbing
- checker 还在看
