=========
 tornado
=========

cookie_secret
==============

.. code:: python

    from uuid import uuid4
    from base64 import b64encode
    cookie_secret = b64encode(uuid4().bytes + uuid4().bytes)
