# PTC vs TCO

https://www.lua.org/pil/6.3.html
https://lucasfcosta.com/2017/05/08/All-About-Recursion-PTC-TCO-and-STC-in-JavaScript.html

- proper tail calls 说的是运行时的表现
    - the interpreter that support proper tail calls do not use any extra stack space when doing a tail call
- tail call optimization 说的是编译器的优化
    - tail call optimization is a technique used by the compiler to transform recursive calls into a loop
