====================
 angularjs tutorial
====================

basic
======

in html template

.. code:: html

    <html ng-app>
        <head>
            <title>angularjs tutorial</title>
            <script src="angular.js"></script>
            <script src="controller.js"></script>
        </head>
        <body ng-controller="controller_example">
            <p>{{ my_attr }}</p>
        </body>
    </html>


in ``controller.js``

.. code:: js

    function controller_example($scope) {
        $scope.my_attr = 'blahblah';
    }

it is no need to put ``angular.js`` at the bottom of body.

-------------------------------------------------------------------------------

loop
=====

.. code:: html

    <!-- my_var shoule be defined in controller. -->
    <ul>
        <li ng-repeat="loop_value in my_var">
        {{ loop_value }}
        </li>
    </ul>

    <!-- range loop -->
    <ul>
        <li ng-repeat="loop_value in [1,2,3,4,5]">
        {{ loop_value }}
        </li>
    </ul>

-------------------------------------------------------------------------------

binding data
=============

.. code:: html

    <html ng-app>
        <head>
            <title ng-bind-template="{{ title_model }}">not use</title>
            <script src="angular.js"></script>
        </head>
        <body>
            <label>title: <input ng-model="title_model" /></label>
        </body>
    </html>

-------------------------------------------------------------------------------

mvc
====

request data from server.

.. code:: html

    <html ng-app ng-controller="WTF">
        <head>
            <title>mvc</title>
            <srcipt src="angular.js"></script>
            <srcipt src="controller.js"></script>
        </head>
        <body>
            <ul><li ng-repteat="loop_var in my_var">{{loop_var}}</li></ul>
        </body>
    </html>

.. code:: js

    var WTF = function($scope, $http) {
        $http.get('data.json').success(function(data) {
            $scope.my_var = data;
        });
    };

-------------------------------------------------------------------------------

argument
=========

minify will rename argument which broke angular's controller.
just write controller in this way:

.. code:: js

    var controller_example = [
        '$scope', '$http',
        function($scope, $http) {
            // ...
        }
    ];

-------------------------------------------------------------------------------

src
====

use :code:`ng-src` instead of :code:`src`.

.. code:: html

    <img ng-src="{{ img_link }}">

-------------------------------------------------------------------------------

route
======

+ ``app.js``
+ ``controller.js``
+ ``index.html``
+ ``view.html``

.. code:: js

    // app.js
    angular.module("app_name", []).config(
        ["$routeProvider", function($routeProvider) {
            $routeProvider.
                when("/", {templateUrl: "./view.html", controller: wtf}).
                when("/404", {templateUrl: "./404.html"}).
                otherwise({redirectTo: "/404"});
        }]
    );

    // controller.js
    var wtf = ['$scope', '$http', function($s, $h) {
        $h.get("./data.json").success(function(data) {
            $s.my_json = data;
        });
    }];

    // index.html
    <!DOCUMENT html>
        <html ng-app="app_name">
        <head>
            <title>route example</title>
            <script src="./angular.js"></script>
            <script src="./app.js"></script>
            <script src="./controller.js"></script>
        </head>
        <body>
            <a href="#/">index</a>
            <a href="#/404">404</a>
            <div ng-view></div>
        </body>
    </html>

    // view.html
    <pre><code>{{ my_json | json }}</code></pre>

**caution**: the link must start with ``#``.

-------------------------------------------------------------------------------

filter
=======

add custom filter to module.

.. code:: js

    // create filter module
    angular.module("filter_module", []).filter("filter_name", function() {
        return function(input) {
            return input ? "\u2713" : "\u2718";
        };
    });

    // use filter module
    angular.module("app_name", ["filter_module"]).config([...]);


use filter.

.. code:: html

    <p ng-repeat="i in [1,2,3,4,5,6]">
        {{ i | filter_name }} <!-- i is the argument pass to filter -->
    </p>

-------------------------------------------------------------------------------

event
======

.. code:: js

    var controller_example = ["$scope", function(s) {
        s.my_var = "blahblah";
        s.set_var = function(val) {
            s.my_var = val;
        };
    }];

.. code:: html

    <p> {{ my_var }} </p>
    <label>range:
    <input type="range" max=100 min=0 step=1 ng-change="set_var()"/>
    </label>

