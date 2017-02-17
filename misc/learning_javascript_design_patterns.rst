.. contents::



category
==========

creational
-----------
用于创建对象。

+ factory method (class)
    创建实例。

+ abstract factory (object)
    用于多个类的实例。

+ builder (object)
    将结构和表现分离，创建同类对象。

+ prototype (object)
    用于复制。

+ singleton (object)
    对象只有一个实例。

structural
------------
用于构建类。

+ adapter (class) (object)
    让接口不同的类能够协作。

+ bridge (object)
    分离类的接口和实现，使之独立。

+ composite (object)
    将多个对象组合起来。

+ decorator (object)
    向对象动态地添加新方法。

+ facade (object)
    隐藏具体实现。

+ flyweight (object)
    用于进行信息共享。

+ proxy (object)
    某个对象的占位符。


behavioral
------------
如何工作。

+ interpreter (class)

+ template method (class)
    由子类来实现具体方法。

+ chain of responsibility (object)
    在链中传递对象，让其中合适的方法来处理对象。

+ command (object)
    将命令封装成一个对象。

+ iterator (object)
    遍历容器。

+ mediator (object)
    为不同的类提供沟通渠道。

+ memento (object)
    捕获对象内部状态，以便后期回到这个状态。

+ observer (object)
    将变化告知其他类，保持类的一致性。

+ state (object)
    当状态改变时，改变对象的行为。

+ strategy (object)
    对类内的算法进行封装，变成可选的实现。

+ visitor (object)
    在不改变类的前提下，为类添加新操作。







MV*
=====


MVVM
------

model
    模型只是持有数据信息，不负责处理具体行为。
    如何展示数据由视图负责，业务逻辑之类的行为由视图模型负责。

view
    被动视图只是展示数据，不接受用户输入。
    主动试图包含了数据绑定、事件和行为，需要对视图模型有所了解。

    在 KnockoutJS 里面， 视图就是 html 加上数据绑定。
    视图展示视图模型里的信息，并将用户指令传递给视图模型。

view model
    视图模型是一个中间层，负责进行数据转换。
    将模型里的信息转换成适合视图展示的信息，
    将视图接收到的命令传递给模型。





design patterns
=================


singleton
------------

1. 在任意一个应用场景中，这个类的用法都是相同的。
2. 在任意一个应用场景中，这个类都只能有一个实例。
3. 使用这个类的客户端，不应该关注到其应用场景。

真的不知道到底为啥要有 singleton。



observer
----------


