basic
======

Model-View-View Model (MVVM)

model 即 数据。
view 即 html。
view model 即 js。


.. code:: html

    <span data-bind="text: fullname"></span>
    <script>
        function ViewModel() {
            this.name = ko.observable('name');

            this.fullname = ko.computed(function() {
                return this.name();
            }, this);
        }

        var vm = new ViewModel();

        ko.applyBindings(vm);
    </script>





自定义绑定类型
===============

.. code:: javascript

    ko.bindingHandlers.bindingName = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {},
        update: function(elem, value, bindings, vm, context) {}
    };

第一次调用绑定的时候，会调用 ``init`` 方法。
用来初始化状态、设置事件处理函数等。

每次调用绑定的时候，都会调用 ``update`` 方法。
用来更新数据。

两种方法的参数是一样的。

+ ``element`` 是绑定的元素。
+ 调用 ``valueAccessor`` 可以获得监听的对象。
+ 调用 ``allBindingsAccessor`` 可以获得绑定的所有对象。
+ ``viewModel`` 是绑定的视图模型。
+ ``bindingContext`` 里面是诸如 ``$data, $parent, $root`` 之类的东西。





监听对象
=========
可以给监听的对象加上回调函数，在特定状态下进行调用。

.. code:: javascript

    function VM() {
        this.key = ko.observable('value');
    }
    var vm = new VM();

    var subBefore = vm.key.subscribe(function(oldValue) {
        console.log('old value: ' + oldValue);
    }, null, 'beforeChange');

    var subAfter = vm.key.subscribe(function(newValue) {
        console.log('new value: ' + newValue);
    });
    // 2nd argument is context, which will be bound to `this`
    // 3rd argument is event, use `change` by default

    vm.key('example');

    subBefore.dispose();
    subAfter.dispose();






扩展绑定
=========

.. code:: javascript

    ko.extenders.log = function(target) {
        console.log('value: ' + target());
        return target;
    }

    ko.extenders.num = function(target, precision) {
        var ret = ko.computed({
            read: target,
            write: function(newValue) {
                var val = Number(newValue).toFixed(precision);
                target(val);
            }
        });
        ret(target());
        return ret;
    };
    var vm = {
        before: ko.observable('100').extend({ log: undefined, num: 2 }),
        after: ko.observable('100').extend({ num: 3, log: undefined })
    };
    ko.applyBindings(vm);


首先是向 ``ko.extenders`` 添加新的方法。
新方法的地一个参数是调用这个被拓展的 ``observable`` ，
第二个参数是传进的参数。
返回值应该是一个 ``observable`` 对象，可以是原来的，也可以是修改过的。

调用的时候，使用 ``extend`` 方法，将要调用的方法放进去。
可以使用调用多个方法，但是顺序有影响。




throttle
=========
``throttle`` 是个内置的拓展，用来延迟计算。

.. code:: javascript

    function ViewModel() {
        this.name = ko.observable('CamelCase');
        this.upper = ko.computed(function() {
            return this.name().toUpperCase();
        }, this).extend({ throttle: 1000 });
    }
    ko.applyBindings(new ViewModel());

上面这个例子，在 ``name`` 改变一秒后，才会重新计算 ``upper`` 。

在与服务器交互的时候，尤其有用。
可以等待数据都修改好之后，再一次性向服务器提交。
下面的例子来自官网。

.. code:: javascript

    function ViewModel() {
        this.pageSize = ko.observable(20);
        this.pageIndex = ko.observable(1);
        this.pageData = ko.observableArray();
        ko.computed(function() {
            var params = {
                page: this.pageIndex(),
                size: this.pageSize()
            };
            $.getJSON('url', params, this.pageData);
        }).extend({ throttle: 1 });
    }
    var vm = new ViewModel();



视图更新
=========
在上面的例子里，不使用 ``throttle`` 的话，
每次修改 ``pageSize`` 或 ``pageIndex`` ，
都会向服务器发起请求。
加上 ``throttle`` 之后，则会等待修改都完成，才发起请求。

下面讲下，请求是怎么被触发的。

初始化视图的时候，会发起一次请求，这个不用说。
修改 ``pageSize`` 之后又如何呢？

关键在于 ``computed`` 。
`ko` 在执行 ``computed`` 的时候，
会记录下计算属性需要读取的 ``observable`` 对象。
然后使用 ``subscribe`` 给这些对象加上回调函数，监视这些对象的修改。
对象修改之后，回调函数会重新计算整个 ``computed`` 里的对象。

如果不想因为某些数据的修改而触发更新，可以使用 ``peek`` 方法。

.. code:: javascript

    function ViewModel() {
        this.update = ko.observable(1);
        this.notUpdate = ko.observable(2);
        this.sum = ko.computed(function() {
            return this.update() + this.notUpdate.peek();
        }, this);
    }

单纯修改 ``notUpdate`` 不会更新 ``sum`` ，
要修改 ``update`` 时，才重新计算 ``sum`` ，包括 ``notUpdate`` 的修改。

应该避免 ``computed`` 对象间的循环依赖。
