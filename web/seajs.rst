引入非标准 CMD 模块
====================
https://github.com/seajs/seajs/issues/448

要引入其他包，原来感觉有点麻烦，最后发现这个，怎么没看其他地方提到呢……

.. code:: javascript

    // ko.js
    define(['path/to/knockout.js'], function() {
        return ko;
    });

    // app.js
    define(function(require) {
        var ko = require('path/to/ko.js');
        var viewModel = {};
        ko.applyBindings(viewModel);
    });


不过这样还是把 ``ko`` 引入了 ``window`` ，所以干脆这样：

.. code:: javascript

    define(
        ['path/to/jquery.js', 'path/to/knockout.js'],
        function(require) {
            var viewModel = {};
            ko.applyBindings(viewModel);
        }
    );
