修改标题
=========
``ko.applyBindings`` 默认是绑定到 ``body`` 上的。
如果要动态修改标题（比如 ``<title data-bind="text: title"></title>`` ），
要绑定到整个 html 上，
也就是 ``ko.applyBindings(vm, document.querySelector('html'))`` 。
