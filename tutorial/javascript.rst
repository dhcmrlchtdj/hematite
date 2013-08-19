提交表单
=========
如果表单中带有提交按钮，在点击 ``Enter`` 时就会提交表单。
如果没有提交按钮， ``Enter`` 不会提交表单。
一个例外是 ``textarea`` ，在框里回车是换行。

所谓提交按钮，也就是
``input[type=submit]`` 和 ``input[type=image]`` 和 ``button[type=submit]`` 。

:code:`form.submit()` 不会触发 :code:`submit` 事件。

另外一点，如果使用 :code:`display:none` 来隐藏元素，chrome 会无视这个元素。
如果把提交按钮隐藏了， ``Enter`` 就无效了。
应该使用 :code:`visibility:hidden` 来隐藏元素。






定时器
=======
js 里有 :code:`setTimeout` 和 :code:`setInterval` 两种定时器，
前者是超时调用，后者是间歇调用，这个不用多说。

那么，下面的代码，两者的区别在哪里？

.. code:: javascript

    var doSomething = function() {};

    setTimeout(function repeat() {
        doSomething();
        setTimeout(repeat, delay);
    }, 10);

    setInterval(function repeat() {
        doSomething();
    }, 10);

两者看起来都是每 10 毫秒调用函数一次，但在具体执行的时候，还是存在细微的差异。

首先，我们知道 js 在是单线程的。
这里我们忽略调度的细节，把要执行的函数想象成一个任务队列。


:code:`setTimeout` 在 10 毫秒后调用函数，也就是把函数加入了任务队列。
如果队列中没有其他代码在执行或等待，结果就和预期的一样。
如果队列中有很多其他函数正在等待，那么这个超时调用就要慢慢排队，
等待的时间就有可能超过 10 毫秒。
执行后，会再次尝试在 10 毫秒后调用函数，也就是重复前面的过程。


:code:`setInterval` 则是每隔 10 毫秒，就尝试调用函数一次。
也就是，10 毫秒时试一次，20 毫秒时试一次，30 毫秒时试一次……
如果没碰上排队，就这样了。
如果碰上要排队的情况，也就是没能调用函数，函数就加入任务队列，等待执行。
特别的是，可能出现超过时间间隔，函数还在排队的情况。
如果 10 毫秒加入队列的函数在 20 毫秒时还没执行，
20 毫秒时的函数是不会加入队列的，也就是说，
:code:`setInterval` 要调用的函数，不会在队列中出现两次。


**总结** 就是，两者的区别在于对这个间隔的处理。
其实就像函数名暗示的那样，
一个是结束之后多少毫秒加入队列，一个是每多少毫秒加入队列。





new
====
我们使用一个函数作为构造函数（constructor），来 :code:`new` 一下。
下面解释下 :code:`new` 的时候，都干了什么。

.. code:: javascript

    function Example(args) {
        this.blahblah = args;
    }

    example = new Example('wtf');

在上面这个例子里，构造函数 :code:`Example` 没有 :code:`return` 语句，
而且里面引用了 :code:`this` ，那么 :code:`example` 到底是什么呢。

实际上， :code:`new` 会先构造一个空对象（ :code:`{}` ），
在这个空对象上执行构造函数（就是把这个对象绑定到构造函数的 :code:`this` 上），
最后返回这个对象。

.. code:: javascript

    example = {};
    Example.call(example, 'wtf');

就是上面这种感觉吧。
不过还是有区别的，手动生成的对象不会被视为构造函数的实例。

如果构造函数带有 :code:`return` 语句会怎么样？

.. code:: javascript

    function Ex1() {
        return 'wtf';
    }

    function Ex2() {
        return ['wtf'];
    }

    function Ex3() {
        return {'ex3': 'wtf'};
    }

    console.log(new Ex1());
    console.log(new Ex2());
    console.log(new Ex3());

看了上面的代码，估计也能猜出来了一点。
使用 :code:`new` 的时候，返回值必须是对象类型的值，
如果返回基本类型的值， :code:`return` 会被无视掉，返回 :code:`this` 。

最后， :code:`new A` 和 :code:`new A()` 的效果是一样。
只能说，:code:`new` 和构造函数以及括号，三者是个整体，
如果插入括号改变运算优先级，会改变整个语句的语义。





new 续
=======

.. code:: javascript

    (function() {
        var ex2 = function() {
            return this.name;
        };

        function Person(name) {
            this.name = name;
            this.ex1 = function() {
                return this.name;
            };
            this.ex2 = ex2;
        }

        Person.prototype.ex3 = function() {
            return this.name;
        };

        var a = Person('a');
        var b = Person('b');
        console.log(a.ex1 === b.ex1); // false
        console.log(a.ex2 === b.ex2); // true
        console.log(a.ex3 === b.ex3); // true
    })();

构造函数内部定义的属性，都是重新创建再赋给新对象的，所以都是不同的个体。
在内部定义的函数，虽然功能相同，但却是不同的函数。
想要重用函数，就不能放在构造函数内声明。
可以在外部声明，在构造函数中获取引用。
也可以赋值给构造函数的原型。

实例和构造函数没有直接联系，而是共享了 *构造函数的原型* 。
原型里的的 :code:`constructor` 属性又指向了构造函数。






eval
=====
:code:`eval` 能够获取执行时的作用域，
执行的最后一条表达式会作为 :code:`eval` 的返回值。

在 :code:`use strict` 的的约束下，
:code:`eval` 无法在执行的作用域中声明新的变量或函数，
可以理解成，代码是在一个新的函数作用域中执行的。

还是可以通过返回值以及修改外部变量的方式来交流就是了。






DOM 节点属性
=============
节点属性算是一个坑。

.. code:: javascript

    var body = document.body;

    body.id = 'property';
    console.log( body.id );

    body.setAttribute('id', 'attribute');
    console.log( body.getAttribute('id') );

    body.getAttributeNode('id').nodeValue = 'attributeNode';
    console.log( body.getAttributeNode('id').nodeValue );

上面三种方法都可以获取和修改节点的属性。

:code:`getAttributeNode` 没啥亮点，这里不展开了。

使用 :code:`getAttribute` 和 :code:`setAttribute`
来操作节点的属性（attribute）在大部分情况下是个好选择，
没有非常突出的问题。

直接操作节点的属性（property）需要注意几点：

+ 属性名的限制

  属性名在 js 和 html 中不是一一对应的。典型代表就是 :code:`className` 。
  在 js 中，属性名称受 js 的命名限制，不能与保留字冲突，通常采用小骆驼命名法。

+ 自定义属性

  可以直接用属性操作的只有 html 规定的标准属性，自定义的属性是取不到的。
  不过 :code:`data-` 开头的自定义属性可以通过 :code:`dataset` 属性获取。

+ 表单

  在表单中，使用属性（property）可以直接获取相应的表单项，
  这里的相应指的是项的 :code:`id` 或者 :code:`name` 属性。
  换句话说，这些属性被项覆盖了，也就无法通过属性（property）来获取和修改了，
  这种时候就需要使用 :code:`getAttribute` 。

+ 链接

  使用属性（property）来获取节点的 url ，
  比如 :code:`src` :code:`href` :code:`action` ，
  其结果都是被浏览器补全了的，
  要获取 html 原始值，要使用 :code:`getAttribute` 。


早期的 IE 版本从来都是地狱，这里不细说。
css 样式是个比一般属性更大的坑，这里也不展开了。







逗号运算符
===========

.. code:: javascript

    (function() {
        var window = this || (0, eval)('this');
    })()





CommonJS Modules/1.1.1
=======================

通用 JS 模块规范（？）

规范定义了 ``require`` 函数。

1. 接受一个模块标识作为参数。
2. 返回值是模块提供的 API。
3. 如果出现循环依赖，会返回已执行的部分结果。
4. 如果没能获取模块，抛出错误。
5. `main` 属性。只读。值为 ``undefined`` 或模块标识。
6. `paths` 属性。队列。在全局都是唯一的。会被用于解析模块的地址。

在模块中

1. 可以调用 ``require`` 函数。
2. 使用 ``exports`` 向外提供 API。
3. 对象 ``module`` 。有 ``id`` 属性，只读，标识该模块。
   有 ``uri`` 属性，指向模块的链接。

模块标识要满足

1. 是由斜干分割的项组成的字符串。
2. 项是使用小骆驼写法的字符串、 `.` 或 `..` 。
3. 可以不以 `.js` 结尾。
4. `.` 和 `..` 开头的标识是相对标识，否则为顶级标识。
5. 顶级标识指向根目录。
6. 相对标识是相对于调用 ``require`` 的模块的路径。


变量声明
=========
我居然一直不知道这个特性：
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/var#var_hoisting

.. code:: javascript

    function ex1() {
        a = 10;
        var a;
    }
    // equal to
    function ex2() {
        var a;
        a = 10;
    }

太恐怖了，一下子让 js 变得难以理解……

.. code:: javascript

    var g = 10;

    (function test1() {
        // 这个很好理解
        console.log(g); // 10
    })();

    (function test2() {
        // 这个也很好理解
        var g = 100;
        console.log(g); // 100
    })();

    (function test3() {
        // 这个一开始看不懂
        console.log(g); // undefined
        var g = 100; // 这里是否赋值，其实没有影响，关键是声明了。
    })();

    (function test4() {
        // 看到这里应该开始能理解了
        g = 100;
        console.log(g); // 100
        var g = 1000; // 把声明和赋值分开看待。
    })();

    (function test5() {
        // 更清晰点
        console.log(g); // undefined
        g = 100;
        console.log(g); // 100
        var g = 1000;
        console.log(g); // 1000
    })();

到这里总结一下。在作用域的任何位置对变量进行声明，声明都对整个作用域有效。
可以理解成声明提升到了作用域的顶端，但是，赋值操作并不会和声明一起提升，
也就是说，变量声明但未赋值，所以就成了 ``undefined`` 了。

然后继续看个例子：

.. code:: javascript

    (function test6() {
        g = 100; // 到底是 window.g 还是函数作用域内的 g 呢？
        console.log(g, window.g); // 100, 10
        return;
        var g; // 没错，连 return 都阻止不了 var 了。
        console.log(g); // 不会执行的。
    })()

最后还有个疑问， ``function`` 和 ``var`` ，都会使变量作用于整个作用域，
如果两个对上，会怎么样？

.. code:: javascript

    (function test8() {
        // 已经知道 var 和 function 都是作用于整个作用域的，
        // 作用时，哪个更靠前，和写的位置有没关系呢？
        var x;
        function x() {};

        function y() {};
        var y;

        console.log(x, typeof x); // function x() {} "function"
        console.log(y, typeof y); // function y() {} "function"
        console.log(z, typeof z); // function z() {} "function"

        return;

        function z() {}; // 这个是顺便验证下 return 和 function 的优先顺序。
    })();

结果表明，和写的位置没关系， ``var`` 是最优先的，然后轮到 ``function`` ，
而 ``return`` 虽然能干掉其他代码，但是管不了这俩。

但是事情还没有结束，最后再提一点， ``var`` 和分支语句的较量。

.. code:: javascript

    (function test9() {
        // 虽然会疑惑下，但也不是不能接受吧。
        g = 100;
        console.log(g, window.g); // 100, 10
        if (false) {
            var g;
        }
    })();

其实 ``return`` 的跪了， ``if`` 的结局也是可以预料的。

总结起来就是，不管在哪个位置，不管这里的代码会不会执行，
只要 ``var`` 出现了，这个变量就在作用域中完成了声明。
（一下子没了难以理解的感觉，只剩下理所当然了……）
