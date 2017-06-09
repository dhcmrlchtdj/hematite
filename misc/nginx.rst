http://nginx.com/admin-guide/

配置
=====

::

    # 配置形式如下
    directive parameters;

    instruction {
        directive parameters;
    }

可以用 `include` 指令引入其他配置

::

    include mime.types;

简单的配置范例

::

    user nobody;
    include mime.types;

    http {
        server {
            listen 80 default;
            location / {
                proxy_pass http://localhost:8000;
            }
        }
    }



反向代理 reverse proxy
========================

::

    http {
        server {
            listen 80;
            location / {
                proxy_pass http://localhost:8000;
            }
        }
    }



nginx 在代理时，会重写 `Host` 和 `Connection` 这两个 http header，同时去掉空值的 header。
如果要修改 http header，可以使用 `proxy_set_header` 指令。

::

    location / {
        proxy_set_header Host $host;
        proxy_set_header Accept-Encoding "";
        proxy_pass http://localhost:8000;
    }

nginx 在代理时，会对服务器的回应进行缓存，直到得到全部数据，再一次性发送。
缓存相关的内容可以查看 http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering 。



负载均衡 load balancing
=========================

+ http://nginx.org/en/docs/http/ngx_http_upstream_module.html
+ http://nginx.org/en/docs/http/load_balancing.html

::

    server {
        upstream backend {
            least_conn; # nginx 自带了三种负载均衡算法

            server http://loachost:8000;
            server http://loachost:8001;
            server http://loachost:8002;
        }
        location / {
            proxy_pass http://backend;
        }
    }



压缩
=====

::

    server {
        gzip on;
        gzip_min_length 1000;
        gzip_proxied any;
        gzip_types text/css text/javascript application/javascript
            text/plain application/atom+xml application/rss+xml;
    }

+ `gzip on` 指示 nginx 压缩 text/html 。
+ gzip_types 指定的类型，也会进行压缩。
+ 只有在回应的体积超过 gzip_min_length bytes 的时候，才会进行压缩。



限制访问
=========

::

    # 限制 ip 访问
    # http://nginx.org/en/docs/http/ngx_http_access_module.html
    location / {
        allow 192.168.1.1/24;
        allow 127.0.0.1;
        deny 192.168.1.2;
        deny all;
    }

    # 使用 http 验证
    # http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html
    server {
        auth_basic "closed website";
        auth_basic_user_file conf/htpasswd;

        location /public/ {
            auth_basic off;
        }
    }

    # 两者结合 满足任意一个即可
    location / {
        satisfy any;

        allow 192.168.1.0/24;
        deny all;

        auth_basic "closed site";
        auth_basic_user_file conf/htpassed;
    }

    # 限制链接数
    http {
        limit_conn_zone $binary_remote_addr zone=addr:10m;
        server {
            limit_conn addr 5;
            location /download/ {
                limit_conn addr 1;
            }
        }
    }
    # 限制速度
    http {
        limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
        server {
            location /search/ {
                limit_req zone=one burst=5;
            }
        }
    }
    # 限制带宽
    location /download/ {
        limit_rate_after 1m; # 最初的 1m 还是不限制的
        limit_rate 50k;
    }




处理静态资源
=============

::

    server {
        root /www/data;
        location / {
        }

        location /static/ {
            root /www/static;
        }
    }





编译安装
=========

::

    $ ./configure ...... --add-module=/path/to/module






控制
=====

向主进程发送信号

+-----------+------------------------------------+
| signal    | usage                              |
+===========+====================================+
| TERM, INT | 关闭进程                           |
+-----------+------------------------------------+
| QUIT      | 当前的请求完成后关闭进程           |
+-----------+------------------------------------+
| HUP       | 重新读取配置                       |
+-----------+------------------------------------+
| USR1      | 重新打开日志                       |
+-----------+------------------------------------+
| USR2      | 更新可执行文件                     |
+-----------+------------------------------------+
| WINCH     | 在执行进程完成请求后，关闭执行进程 |
+-----------+------------------------------------+

向执行进程发送信号

+-----------+--------------------------+
| signal    | usage                    |
+===========+==========================+
| TERM, INT | 关闭进程                 |
+-----------+--------------------------+
| QUIT      | 当前的请求完成后关闭进程 |
+-----------+--------------------------+
| USR1      | 重新打开日志             |
+-----------+--------------------------+
| WINCH     | 关闭进程（用于除错）     |
+-----------+--------------------------+







基本配置
=========

+--------------------+--------------------------------------------+
| directive          | usage                                      |
+====================+============================================+
| worker_processes   | 执行进程的数目。                           |
|                    | 对于 CPU 密集型的程序，设置为 CPU 核心数。 |
|                    | 对于 IO 密集型的程序，                     |
|                    | 设置为 CPU 核心数的 1.5 到 2 倍。          |
+--------------------+--------------------------------------------+
| error_log          | /var/log/nginx/error.log，日志。           |
+--------------------+--------------------------------------------+
| use                | epoll / kqueue                             |
+--------------------+--------------------------------------------+
| worker_connections | 执行进程保持的最大连接数。                 |
+--------------------+--------------------------------------------+
| include            | 可以灵活地添加配置。                       |
+--------------------+--------------------------------------------+
| user               | 执行进程的用户名和用户组。                 |
+--------------------+--------------------------------------------+
| pid                | /var/run/nginx.pid，保存主进程的进程 ID。  |
+--------------------+--------------------------------------------+






http 模块
==========

+-------------------+-------+
| directive         | usage |
+===================+=======+
| keepalive_timeout |       |
+-------------------+-------+
| sendfile          |       |
+-------------------+-------+
| tcp_nopush        |       |
+-------------------+-------+
| tcp_nodelay       |       |
+-------------------+-------+


每个 ``server`` 块都是个虚拟的服务器，
``listen`` 和 ``server_name`` 定义了这个虚拟服务器。

``listen`` 定义了端口和地址，而 ``server_name`` 和请求中的 ``Host`` 对应。

``server_name`` 默认是空值（ ``""`` ），（只）可以在头尾使用通配符 ``*`` ，
也可以使用正则表达式。

::

    server_name example.com www.example.com;
    server_name .example.com; # 会匹配 *.example.com 和 example.com
    server_name fourm.example.com;
    server_name *.example.com;
    server_name www.example.*;
    server_name ~^www\.example\.com$; # 正则要以 `~` 开头
    server_name "~^(?P<name>\w{1,3})\.example\.com$"; # 带 `{}` 的正则要用引号包围

在匹配多个 ``server_name`` 的情况下，会按照如下顺序进行选择：

1. 完整的匹配
2. 最长的前通配符匹配
3. 最长的后通配符匹配
4. 配置中出现的第一个匹配的正则

::

    # 假设有
    server_name www.cn.example.com;
    server_name *.cn.example.com;
    server_name *.example.com;
    server_name www.cn.*;
    server_name www.*;
    server_name ~^.*\.example\..*$;
    # 匹配的顺序就是上面的顺序了

``listen`` 的匹配优先级要比 ``server_name`` 高。

``location`` 用来将虚拟地址映射到真实地址。

::

    location / {
        proxy_pass http://frontend;
    }
    location /static {
        root /var/www/static;
    }

``location`` 可以嵌套，可以使用正则。






跳转
=====
使用 ``return`` 代替 ``rewrite`` 。

::

    # rewrite ^/(.*)$ http://domain.com/$1 permanent;
    # rewrite ^ http://domain.com$request_uri? permanent;

    return 301 http://domain.com$request_uri


``rewrite`` 默认使用相对路径，绝对路径要加上 `http` 。

::

    rewrite ^/blog(/.*)$ blog.domain.com/$1 permanent;

    rewrite ^/blog(/.*)$ http://blog.domain.com$1 permanent;




请求处理
=========
http://wiki.nginx.org/Phases

+--------------------+--+-------------------------+
| phase              |  | directive               |
+====================+==+=========================+
| server selection   |  | listen, server_name     |
+--------------------+--+-------------------------+
| post read          |  |                         |
+--------------------+--+-------------------------+
| server rewrite     |  | rewrite                 |
+--------------------+--+-------------------------+
| location selection |  | location                |
+--------------------+--+-------------------------+
| location rewrite   |  | rewrite                 |
+--------------------+--+-------------------------+
| preaccess          |  |                         |
+--------------------+--+-------------------------+
| access             |  | allow, deny, auth_basic |
+--------------------+--+-------------------------+
| try files          |  | try_files               |
+--------------------+--+-------------------------+
| content            |  |                         |
+--------------------+--+-------------------------+
| log                |  | access_log              |
+--------------------+--+-------------------------+
| post action        |  | post_action             |
+--------------------+--+-------------------------+


多个后端
==========

::

    server {
        listen 80;
        proxy_intercept_errors on;

        location / {
            proxy_pass http://localhost:9001;
            error_page 404 = @fallback;
        }
        location @fallback {
            proxy_pass http://localhost:9002;
        }

出现 404 的页面会被转向到 fallback。
