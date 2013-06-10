=======================
 python web3 interface
=======================

specification
==============

.. code:: python

    def app(environ):
        pass

+ server must invoke the application object using a positional argument.
+ ``environ`` must be a ``dict``, containing CGI-style environment variables.
+ the application object must return a tuple,
  containing ``(status, headers, body)``
  if supported by an async server, return an argumentless callable
  which either return ``None`` or a tuple before.

+ ``status`` is ``bytes`` of the form "999 message".
+ ``headers`` is a ``list`` of ``(header_name, header_value)`` pairs.
  both of strings should be ``bytes``.
+ ``body`` is iterable object yielding zero or more ``bytes``.

+ server must transmit there bytes to client in an unbuffered fashion.
+ server should complete the transmission before requesting another one.
+ application should perform buffer themselves.
+ server should treat there bytes as binary byte sequences.

+ if application object has a `close()` method,
  server must call that method upon completion of request.

environ
--------

key is ``str``, value is ``bytes``.

+---------------------------+------------------------------------------------------+
| key                       | explain                                              |
+===========================+======================================================+
| REQUEST_METHOD            | "GET", "POST" and so on.                             |
+---------------------------+------------------------------------------------------+
| SCRIPT_NAME               | initial portion of url's path that                   |
|                           | corresponds to application object.                   |
|                           | empty if application corresponds to                  |
|                           | the root of server                                   |
+---------------------------+------------------------------------------------------+
| PATH_INFO                 | remainder of url's path that                         |
|                           | designates to request's target.                      |
|                           | empty if url target the application root             |
|                           | and does not have a trailing slash.                  |
+---------------------------+------------------------------------------------------+
| QUERY_STRING              | "key=value", query string.                           |
+---------------------------+------------------------------------------------------+
| SERVER_NAME               | "example.com", hostname.                             |
|                           | HTTP_HOST is preference to SERVER_NAME               |
|                           | to reconstructing the request url.                   |
+---------------------------+------------------------------------------------------+
| SERVER_PORT               | "80", port.                                          |
+---------------------------+------------------------------------------------------+
| SERVER_PROTOCOL           | "HTTP/1.1", protocol.                                |
+---------------------------+------------------------------------------------------+
| CONTENT_TYPE (optional)   | Content-Type in HTTP request                         |
+---------------------------+------------------------------------------------------+
| CONTENT_LENGTH (optional) | Content-Length in HTTP request                       |
+---------------------------+------------------------------------------------------+
| HTTP_Variables (optional) | other HTTP request headers                           |
+---------------------------+------------------------------------------------------+
| web3.version              | ``tuple``. (1, 0) representing web3 version 1.0      |
+---------------------------+------------------------------------------------------+
| web3.url_scheme           | "HTTP", scheme.                                      |
+---------------------------+------------------------------------------------------+
| web3.input                | file-like object, input stream.                      |
+---------------------------+------------------------------------------------------+
| web3.errors               | file-life object, output stream.                     |
+---------------------------+------------------------------------------------------+
| web3.multithread          | ``True`` if application object may be simultaneously |
|                           | invoked by another thread in the same process.       |
+---------------------------+------------------------------------------------------+
| web3.multiprocess         | ``True`` if equivalent application object may by     |
|                           | simultaneously invoked by another process.           |
+---------------------------+------------------------------------------------------+
| web3.run_once             | ``True`` if server expects the application will      |
|                           | only be invoked this one time during                 |
|                           | the life if its containing process.                  |
+---------------------------+------------------------------------------------------+
| web3.script_name          | non-url-decoded SCRIPT_NAME value.                   |
+---------------------------+------------------------------------------------------+
| web3.path_info            | non-url-decoded PATH_INFO value.                     |
+---------------------------+------------------------------------------------------+
| web3.async                | ``True`` if the webserver supports async invocation  |
+---------------------------+------------------------------------------------------+

name of server-defined variables must contain
lower-case letters, numbers, dots and underscore only,
and be prefixed with a name that is unique to the defining server.

example: `mod_web3.some_variable`.


input stream
-------------

web3.input must support following method.

+ ``read(size)``
+ ``readline([size])``
+ ``readlines([size])``
+ ``__iter__()``

application must not use any other methods or attributes of input object.


error stream
-------------

web3.errors must support following method.

+ ``flush()``
+ ``write(str)``
+ ``writelines(str_seq)``

application must not use any other methods or attributes of error object.


return value
-------------

server is responsible for ensuring that correct headers are sent to client.
if the application omits a header required by HTTP, the server must add it.

applications are forbidden from using HTTP/1.1 "hop-by-hop" features or
headers, any equivalent fratures in HTTP/1.0, or ant headers that
would affect the persistence of the client's connection to the web server.

there features are the exclusive province of the actual web server.
server should consider it a fatal error for an application to attempt
sending them, and raise an error if they are supliied as return values from
an application in the headers structure.
