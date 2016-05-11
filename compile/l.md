# module

```
import foo from "/path/to/module"
export bar = foo
```

模块按版本平铺。


#  binding

```
let foo = "string"
let bar = 3.14
```

# comment

```
# comment
# whole line
```

出现后注释整行

# iter

```
for (let x, y z in iter) {
}
```

# loop

```
while (x < y) {
}
```

# cond

```
if (x == y) {
} else if (x > y) {
} else {
}
```

bool only

# type

string(bytes)
number(integer + float)
boolean(true / false)
nil

everything are values, no reference
