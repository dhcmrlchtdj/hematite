修改标题
=========
``ko.applyBindings`` 默认是绑定到 ``body`` 上的。
如果要动态修改标题（比如 ``<title data-bind="text: title"></title>`` ），
要绑定到整个 html 上，
也就是 ``ko.applyBindings(vm, document.querySelector('html'))`` 。




创建视图模型
=============
视图模型（view model）说起来就是个对象，创建的方法有一堆。

我自己的写法是

.. code:: javascript

    function ViewModel() {
        var self = this;
        self.fn = function() {
            self.variable = undefined;
        };
    };

    var viewModel = new ViewModel();
    ko.applyBindings(viewModel);

在内部定义的函数，都只通过 ``self`` 变量来操作视图模型。
全部通过 ``self`` 来操作的话，习惯了也更容易看些。
实现全都放在构造函数内部。

我觉得这样就挺好的了。

今天在 so 上看到另一种做法

.. code:: javascript

    // from http://stackoverflow.com/questions/9589419/difference-between-knockout-view-models-declared-as-object-literals-vs-functions#answer-16756777
    var viewModel = (function() {
        var self = {};
        self.fn = function() {
            self.variable = undefined;
        };
        return self;
    })();
    ko.applyBindings(viewModel);

两种方法看起来也没差多少，后者少了一个生成实例的过程，
也失去了生成多个实例的能力。

说来用前面的方法生成多个实例的时候，内部定义的函数是独立的，
这倒是真正的额外开销。

再写下去就成了讨论 js 的类和继承了……

我自己更倾向于使用构造函数的方法吧。
