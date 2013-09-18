提交表单
=========
如果表单中带有提交按钮，在点击 ``Enter`` 时就会提交表单。
如果没有提交按钮， ``Enter`` 不会提交表单。
一个例外是 ``textarea`` ，在框里回车是换行。

所谓提交按钮，也就是
``input[type=submit]`` 和 ``input[type=image]`` 和 ``button[type=submit]`` 。

``form.submit()`` 不会触发 ``submit`` 事件。

另外一点，如果使用 ``display:none`` 来隐藏元素，chrome 会无视这个元素。
如果把提交按钮隐藏了， ``Enter`` 就无效了。
应该使用 ``visibility:hidden`` 来隐藏元素。

更新：
``button`` 有个容易忽略的地方，如果没有指定 ``type`` ，默认是 ``submit`` 。







定时器
=======
js 里有 ``setTimeout`` 和 ``setInterval`` 两种定时器，
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


``setTimeout`` 在 10 毫秒后调用函数，也就是把函数加入了任务队列。
如果队列中没有其他代码在执行或等待，结果就和预期的一样。
如果队列中有很多其他函数正在等待，那么这个超时调用就要慢慢排队，
等待的时间就有可能超过 10 毫秒。
执行后，会再次尝试在 10 毫秒后调用函数，也就是重复前面的过程。


``setInterval`` 则是每隔 10 毫秒，就尝试调用函数一次。
也就是，10 毫秒时试一次，20 毫秒时试一次，30 毫秒时试一次……
如果没碰上排队，就这样了。
如果碰上要排队的情况，也就是没能调用函数，函数就加入任务队列，等待执行。
特别的是，可能出现超过时间间隔，函数还在排队的情况。
如果 10 毫秒加入队列的函数在 20 毫秒时还没执行，
20 毫秒时的函数是不会加入队列的，也就是说，
``setInterval`` 要调用的函数，不会在队列中出现两次。


**总结** 就是，两者的区别在于对这个间隔的处理。
其实就像函数名暗示的那样，
一个是结束之后多少毫秒加入队列，一个是每多少毫秒加入队列。





new
====
我们使用一个函数作为构造函数（constructor），来 ``new`` 一个实例。
下面解释下 ``new`` 的时候，都干了什么。

.. code:: javascript

    function Example(args) {
        this.blahblah = args;
    }

    example = new Example('wtf');

在上面这个例子里，构造函数 ``Example`` 没有 ``return`` 语句，
而且里面引用了 ``this`` ，那么 ``example`` 到底是什么呢。

实际上， ``new`` 会先构造一个空对象（ ``{}`` ），
在这个空对象上执行构造函数（就是把这个对象绑定到构造函数的 ``this`` 上），
最后返回这个对象。

.. code:: javascript

    example = {};
    Example.call(example, 'wtf');

就是上面这种感觉吧。
不过还是有区别的，手动生成的对象不会被视为构造函数的实例，
因为无法在 ``example`` 的原型链上找到 ``Example.prototype`` 。

如果构造函数带有 ``return`` 语句会怎么样？

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
使用 ``new`` 的时候，返回值必须是对象类型的值，
如果返回基本类型的值， ``return`` 会被无视掉，返回 ``this`` 。

最后， ``new A`` 和 ``new A()`` 的效果是一样。
只能说， ``new`` 和构造函数以及括号，三者是个整体，
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
原型里的的 ``constructor`` 属性又指向了构造函数。






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

``getAttributeNode`` 没啥亮点，这里不展开了。

使用 ``getAttribute`` 和 ``setAttribute``
来操作节点的属性（attribute）在大部分情况下是个好选择，
没有非常突出的问题。

直接操作节点的属性（property）需要注意几点：

+ 属性名的限制

  属性名在 js 和 html 中不是一一对应的。典型代表就是 ``className`` 。
  在 js 中，属性名称受 js 的命名限制，不能与保留字冲突，通常采用小骆驼命名法。

+ 自定义属性

  可以直接用属性操作的只有 html 规定的标准属性，自定义的属性是取不到的。
  不过 ``data-`` 开头的自定义属性可以通过 ``dataset`` 属性获取。

+ 表单

  在表单中，使用属性（property）可以直接获取相应的表单项，
  这里的相应指的是项的 ``id`` 或者 ``name`` 属性。
  换句话说，这些属性被项覆盖了，也就无法通过属性（property）来获取和修改了，
  这种时候就需要使用 ``getAttribute`` 。

+ 链接

  使用属性（property）来获取节点的 url ，
  比如 ``src`` ， ``href`` ， ``action`` ，
  其结果都是被浏览器补全了的，
  要获取 html 原始值，要使用 ``getAttribute`` 。


早期的 IE 版本从来都是地狱，这里不细说。
css 样式是个比一般属性更大的坑，这里也不展开了。





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


更新：

.. code:: javascript

    (function test10() {
        var x = 100;
        function x() {}

        function y() {}
        var y = 100;
        console.log(x, y); // 100 100
    })();

这个也好解释， ``var`` 提升了， ``function`` 提升了，所以赋值就成了最后的操作。





Object.create 继承
===================
http://docs.webplatform.org/wiki/concepts/programming/javascript/inheritance

.. code:: javascript

    function Super(name) {
        this.name = name;
    }
    Super.prototype.getName = function() { return this.name; };

    function newInherit(name, age) {
        Super.call(this, name);
        this.age = age;
    }
    newInherit.prototype = new Super();
    newInherit.prototype.getAge = function() { return this.age; };

    function createInherit(name, age) {
        Super.call(this, name);
        this.age = age;
    }
    createInherit.prototype = Object.create(Super.prototype, {
        getAge: {
            value: function() { return this.age; }
        }
    });
    // createInherit.prototype.getAge = function() { return this.age; };

能达到相同的效果，做法也很相似，只是用 ``Object.create`` 替换 ``new`` 。
给子类的原型添加方法的时候，可以使用 ``Object.create`` 的语法，
也可以直接在原型上修改。

``new`` 实现继承，靠的是原型指向了父类的一个实例，靠这个实例访问父类的原型。
``Object.create`` 实现继承也是一样的原理。

.. code:: javascript

    var p1 = new Super();
    console.log(p1 instanceof Super); // true

    var p2 = Object.create(Super.prototype);
    console.log(p2 instanceof Super); // true

先扯下 ``instanceof`` 关键字，
MDN 上的解释说 ``instanceof`` 会在对象的原型链上查找构造函数的原型，
找到就返回 ``true`` ，否则返回 ``false`` 。

也就是说，沿着 ``p1.__proto__`` 找到了 ``Super.prototype`` ，
沿着 ``p2.__proto__`` 也找到了 ``Super.prototype`` 。
（ ``Object.getPrototypeof(obj)`` 比 ``obj.__proto__`` 标准些。）

那么 ``p1`` 和 ``p2`` 区别在哪里呢？
其实相比 ``new`` ，
``Object.create`` 就是去掉了绑定 ``this`` 后执行构造函数的过程，
只是把把参数放到了新对象的原型上。
注意下这里的原型是 ``__proto__`` 不是 ``prototype`` 。

可以这么理解

.. code:: javascript

    function A() {}

    var ex1 = Object.create(A.prototype);
    console.log(ex1.__proto__ === A.prototype); // true

    var ex2 = { __proto__: A.prototype };
    console.log(ex2.__proto__ === A.prototype); // true




最后两个例子

.. code:: javascript

    var ex1 = Object.create(null);
    console.log(ex1 instanceof Object); // false
    console.log(Object.getPrototypeof(ex1) === null); // true
    console.log(ex1.__proto__ === undefined) // true
    // 只能说 null 是个异类


    function Super() {}
    function Sub() {}
    Sub.prototype = Object.create(Super.prototype);
    Sub.prototype.constructor = Sub;
    var instance = new Sub();

    console.log(instance instanceof Sub); // true
    // instance.__proto__ === Sub.prototype
    console.log(instance instanceof Super); // true
    // instance.__proto__.__proto__ === Super.prototype

    console.log(Sub.prototype instanceof Super); // true
    // Sub.prototype.__proto__ === Super.prototype
    console.log(Sub instanceof Super); // false
    // Sub.__proto__ !== Super.prototype






原型
=====
自己看上面的文字都有点看乱了。

``__proto__`` 和 ``prototype`` 都可以叫原型，但确实是不同的东西。

+ ``obj.__proto__`` 或者说 ``Object.getPrototypeOf(obj)`` ，
  是对象的内部属性 ``[[Prototype]]`` 。

+ ``prototype`` 是函数属性，里面的 ``constructor`` 属性指向构造函数。

继承时，查找的是实例的 ``__proto__`` ，也就是类的 ``prototype`` ，
继续向上时，找的是类的 ``prototype.__proto__`` ，也就是父类的 ``prototype`` 。

再重复一次，实例和构造函数没有直接联系，而是共享了 *构造函数的原型* 。
``class.prototype === instance.__proto__`` 。



类型转换
=========
+ http://ecma-international.org/ecma-262/5.1/#sec-9
+ http://es5.github.io/x9.html
+ http://es5.github.io/x8.html#x8.12.8
+ http://people.mozilla.org/~jorendorff/es6-draft.html#sec-9.1

下面挑着说。

+ ``Object`` 在转换为基本类型时，又分为转换为字符串和转换为数值。


+ 假值只有 ``Undefined`` ``Null`` ``false`` ``+0`` ``-0`` ``NaN`` 。
  前两个是类型，但值都只有一种，两个 0 和起来，一共是 5 个假值。


+ 在转换为数字时， ``Undefined`` 是 ``NaN`` ，而 ``Null`` 是 ``+0`` ，
  顺便一提 ``false`` 也是 ``+0`` 。

  ``Object`` 要先转为数值基本类型，再转换为数值。


+ 在转换为整数时， ``NaN`` 被视为 ``+0`` 。

  取整时是向 0 取整，公式为 ``sign(number) * floor(abs(number))`` 。


+ 在转换为字符串时， ``+0`` ``-0`` 都被转换为 ``0`` 。

  ``Object`` 要先转换为字符串基本类型，再转换为字符串。


+ ``Undefined`` 和 ``Null`` 是不能转换为对象类型的。


+ ``Object`` 在转换为字符串型基本类型时，
  1. 首先获取对象的 ``toString`` 方法。
  2. 如果调用 ``toString`` 能返回基本类型的值，那么返回该值。
  3. 获取对象的 ``valueOf`` 方法。
  4. 如果调用 ``valueOf`` 能返回基本类型的值，那么返回该值。
  5. 都不行了就抛出错误。


+ ``Object`` 在转换为数值型基本类型时，
  只是把调用 ``valueOf`` 和 ``toString`` 的顺序对掉一下，
  其他处理是一样的。

+ ``Object`` 在转换成基本类型时，如果没有规定要转换成什么类型，
  默认是转换成数值型。

  当然也有例外， ``Date`` 在没有规定转换类型的情况下，默认是转成字符串型的。


最后给个演示代码：

.. code:: javascript

    var obj = {};
    obj.valueOf = function() { return 100; };
    obj.toString = function() { return "blah"; };

    console.log(Number(obj)); // 100
    console.log(String(obj)); // "blah"



加法
=====
+ http://es5.github.io/x11.html#x11.6.1
+ http://www.2ality.com/2012/01/object-plus-object.html

前面谈类型其实是为了讲讲加法运算。
具体看规范定义，下面简单描述下。

首先是计算左值右值，获取基本类型。
然后看左右是否有字符串出现，出现了字符串，就把两者都转换为字符串再拼接起来。
没有字符串，就把两者都转换成数值再相加。

数值加法按如下方式处理

1. 出现了 ``NaN`` ，返回 ``NaN`` 。
2. ``Infinity`` 和 ``-Infinity`` ，返回 ``NaN`` 。
3. 符号相同的无穷大相加，无穷大。
4. 有限值与无穷大相加，无穷大。
5. 两个 ``-0`` 结果是 ``-0`` ，
   而 ``-0`` ``+0`` 还有 ``+0`` ``+0`` 的结果都是 ``+0`` 。
6. 零值和非零值相加，结果是非零值。
7. 绝对值相等但符号相反的两个值相加，结果是 ``+0`` 。
8. 其他和正常加法定义一样了。


尝试理解下：

.. code:: javascript

    console.log( {} + {} ); // "[object Object][object Object]"
    // valueOf 返回的是对象，所以采用了 toString 的结果，
    // 最后成了两个字符串相加

    console.log( new Date() + [] ); // "XXXXXXXXXXXXXXX"
    // Date 默认是转换成字符型，[] 的情况和 {} 相同，
    // 所以也是字符串相加。

    console.log( null + "blah" ); // "nullblah"
    // null 就是 null，右边出现了字符串，所以成了 "null"。

    console.log( null + false ); // 0
    // null 和 false，没有字符串，所以两个都转换成数值，都是 +0 。

    console.log( false + undefined ); // NaN
    // 同样没有字符串，但是 undefined 转换后成了 NaN。

    console.log( [] + NaN ); // "NaN"
    // [] 返回的是字符串，那么就是字符串了。

    var obj = {}; obj.valueOf = function() {return 9527;};
    console.log( obj + true ); // 9528
    // 自己定义了 valueOf，返回了基本类型的值，所以不会继续调用 toString 了。
    // 最后变成两个数字相加。





void
=====
毫无意义（？）的关键字。
计算表达式并返回 ``undefined`` 。
能够在 ``undefined`` 被覆盖的时候获取 ``undefined`` 。





eval
=====
+ http://perfectionkills.com/global-eval-what-are-the-options/

在直接执行的情况下， ``eval`` 能够获取执行时的作用域，
执行的最后一条表达式会作为 ``eval`` 的返回值。

在 ``use strict`` 的的约束下，
``eval`` 无法在执行的作用域中声明新的变量或函数，
可以理解成，代码是在一个新的函数作用域中执行的。

还是可以通过返回值以及修改外部变量的方式来交流就是了。


如果是间接执行， ``eval`` 会是在全局作用域中执行代码。

.. code:: javascript

    (function() {
        var window = this || (0, eval)('this');
    })()

上面的代码中， ``(0, eval)`` 就是间接执行，通过全局作用域的中执行 ``this`` ，
获取对 ``window`` 的引用。






delete
=======
+ http://perfectionkills.com/understanding-delete/

简单讲，就是用来删除一个对象的属性（也包括数组的元素）。
不能删除普通变量、函数、函数参数

但事情往往没那么简单：

.. code:: javascript

    var x = 10;
    console.log(x, delete x); // 10 false
    y = 10;
    console.log(y, delete y); // 10 true

    try {
        console.log(x); // 10
        console.log(y); // ERROR
    } catch (e) {
        console.log(e.message); // y is not defined
    }

``x`` 没被删除， ``y`` 被删除了。
按理说都是在全局作用域 ``window`` 下声明的变量。

具体还是看给的链接吧。总结起来大概是说：

+ 在全局作用域或函数作用域中声明的变量和函数，不能删除。
+ 函数参数以及各种对象内置属性，不能删除。
+ eval 内声明的变量和函数，可以删除。

再看看上面的代码，简单来说， ``x`` 是在全局作用域下声明的变量，所以不能删除。
而 ``y`` 不是全局作用域下声明的变量，到处都找不到声明，所以丢到了全局作用域，
成了 ``window`` 的一个属性，所以可以删除。





form
=====

.. code:: javascript

    var form = document.querySelector("form");

    form.name; // 表单名
    // form 的 name 属性，可以用 document[name] 直接获取表单

    form.elements; // 表单中的控制元素
    form.length; // 表单元素的个数

    form.enctype; // 编码方式
    form.method; // 提交方式

    form.submit(); // 提交表单，不会触发 submit 事件！
    form.reset(); // 重置表单，这个会触发 reset 事件

可以在提交事件中进行必要的检测，避免重复提交。


.. code:: javascript

    var input = document.querySelector("form input");

    input.form; // 指向 form

    input.type; // 类型
    input.name; // 控件名
    input.value; // 控件当前值


+ ``input`` 和 ``button`` 的类型是可以动态修改的， ``select`` 不行。
+ ``button`` 没有 ``readOnly`` 属性。
+ ``input.value`` 是修改后的值，要获得初始值，
  可以使用 ``input.getAttribute("value")`` 。
  ``textarea`` 可以使用 ``textContent`` 或者 ``innerHTML`` 。
+ chrome 的 ``focus`` 和 ``select`` 有 bug 。
+ 可以用 ``input.selectionStart`` 和 ``input.selectionEnd`` 来获取选中的部分。
  ie9 以下可以使用 ``document.selection`` 。
+ 要选中部分元素可以用 ``input.setSelectionRange()`` 。
  ie9 以下可以使用 ``input.createTextRange()`` 。
+ 可以通过 ``clipboardData.getData("text/plain")`` 获取剪贴板的内容。





XMLHttpRequest
===============
+ 使用 ajax 的方式提交表单的时候，
  应该调用 ``xhr.setRequestHeader`` 将 ``Content-Type`` 设置为
  ``application/x-www-form-urlencoded; charset=UTF-8`` 。
  表单内容必须进行序列化。

  如果觉得太麻烦，也可以使用 ``FormData`` 来生成表单数据，
  那么设置 http 请求头和序列化都可以省了。

+ 使用 ``xhr.overrideMimeType`` 可以设置返回数据的 MIME 类型。
  要在 ``xhr.send`` 之前调用。

+ 要确保避开缓存，去服务器请求数据，可以在链接后面加上 ``？blah`` ，
  也就是查询字符串。如果本来带有查询字符串了，
  可以用 ``&blah`` 附上一个无意义的键名。

+ 异步的请求可以设置一个超时时间， ``xhr.timeout`` 。
  超时了就会触发 ``xhr.ontimeout`` 。

  只有异步请求才可以设置超时。

+ ``xhr.onprogress`` 可以用于监视请求的进度。






valueOf
========
+ http://es5.github.io/x15.2.html#x15.2.4
+ http://es5.github.io/x8.html#x8.6.2
+ http://es5.github.io/x15.4.html#x15.4.3.2
+ http://es5.github.io/x11.html#x11.4.3
+ http://es5.github.io/#x4.3.6
+ http://es5.github.io/#x4.3.8

平常可以用 ``Object.prototype.toString`` 来判断对象类型，
前面知道了， ``valueOf`` 和 ``toString`` 挺相近的，
能不能用 ``valueOf`` 判断类型呢？翻下文档：

``valueOf``
    1. 进行 ``ToObject`` 转换。
    2. 如果是宿主对象，那么结果由实现自己决定。
    3. 返回第一步的转换结果。

    感觉效果和 ``new Object`` 差不多啊，对类型判断完全没帮助。


``toString``
    1. ``undefined`` 返回 ``[object Undefined]`` 。
    2. ``null`` 返回 ``[object Null]`` 。
    3. 进行 ``ToObject`` 转换。
    4. 获取对象的 ``[[Class]]`` 属性。
    5. 返回 ``[object [[Class]]]`` 。

    这个内部属性 ``[[Class]]`` 是个字符串，
    内置对象的取值只有几种： ``Arguments`` ``Array`` ``Boolean``
    ``Date`` ``Error`` ``Function`` ``JSON`` ``Math``
    ``Number`` ``Object`` ``RegExp`` ``String`` 。

    没错，没有 ``Null`` 和 ``Undefined`` ，所以在前面做了预判，实在是简单粗暴。


``Array.isArray``
    顺便看看这个。

    1. 不是引用类型，返回 ``false`` 。
    2. 如果 ``[[Class]]`` 是 ``"Array`` ，返回 ``true`` 。
    3. 返回 ``false`` 。

    其实和 ``Object.prototype.toString`` 一样是检查了 ``[[Class]]`` 。

``typeof``
    回到最基本的判断类型的方法。

    1. 如果找不到，返回 ``undefined`` 。
    2. 照表返回类型。表自己去链接看，下面简述。

       + ``Null`` 型返回 ``object`` 。
       + 其他基本类型就是基本类型
         ``string`` ``number`` ``boolean`` ``undefined`` 。
       + 实现了 ``[[Call]]`` 的对象，返回 ``function`` 。
       + 没实现 ``[[Call]]`` 的原生（native）对象，返回 ``object`` 。
       + 没实现 ``[[Call]]`` 的宿主（host）对象，
         由具体实现自己定义，但不能是基本类型。

    所谓原生对象，就是 ES 规范里面定义了的对象。
    所谓宿主对象，执行环境提供的对象。

    ``typeof`` 判断和 ``[[Class]]`` 完全没有关系。
    ``undefined`` 和 ``null`` 确实有点特殊。





事件监听
=========
照例放链接：

+ http://www.w3.org/TR/DOM-Level-3-Events/#dom-event-architecture
+ http://dom.spec.whatwg.org/#eventlistener
+ http://stackoverflow.com/questions/16273635/how-do-multiple-addeventlistener-work-in-javascript

简单总结几点：

+ ``target.addEventListener`` 把回调函数添加到元素的监听队列上。
  每个回调函数只会被绑定一次（同一事件，同一传播阶段）。
+ DOM2 中没有规定回调函数的执行顺序。
  DOM3 中规定，调用要按照注册的顺序。
+ ``event.stopImmediatePropagation`` 会阻止 **之后** 的回调函数。
  之前的回调函数先执行，不受影响。
+ 回调函数中的 ``this`` 指向了 ``event.currentTarget`` 。
  ``event.target`` 是引起事件的元素。
+ DOM0 注册的事件，在冒泡阶段调用。
+ 在事件处理函数最后 ``return false`` 相当于 ``event.preventDefault()`` 。
  （这个特别拿来讲，是因为 jQuery 里面不一样。）




触发事件
=========
+ https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent

.. code:: javascript

    var link = document.querySelector("#link");
    var e = new CustomEvent("click", {
        bubbles: false,
        cancelable: false,
        detail: { example: "value" }
    });
    link.dispatchEvent(e);

可以用于触发事件。

``CustomEvent`` 的第二个参数用于设置事件，是否冒泡，能否阻止。
``detail`` 可以通过 ``event.detail`` 获取。
