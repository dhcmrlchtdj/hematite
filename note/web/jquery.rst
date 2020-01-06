+ 修改 DOM 的时候，把结果缓存下载，一次性修改。不要每次修改一部分，性能不好。
  可以使用 ``DocumentFragments`` 来暂存 DOM，
  也可以直接用字符串保存 innerHTML 。

+ 循环时缓存长度。

+ 要修改页面的时候，可以考虑先把要修改的部分从页面分离出来，
  修改之后再插回页面。

+ 不要操作不存在的元素。

+ 即使是 ``querySelector`` ，选择器的写法还是会影响性能。

  + 把 id 选择器独立出来。
  + 右边的选择器经可能具体（浏览器是从右往左筛选的）。
  + 尽可能减少选择器的数量。
  + 尽可能不要使用通用选择器。

+ 在修改元素的样式的时候，如果元素较多（超过 20），
  应该考虑使用样式表而不是一个个添加。


+ 在事件处理函数最后 ``return false`` ，
  不仅会调用 ``event.preventDefault()`` ，
  还会调用 ``event.stopPropagation()`` 。

  这点和标准的事件处理函数不一样，要注意下。




ajax FormData
===============

在使用 jquery 发送 FormData 的时候，
要加上 ``processData: false`` 和 ``contentType: false`` 。
