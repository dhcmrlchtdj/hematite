============
 javascript
============

timestamp
==========

.. code::

    // get milliseconds since the epoch
    console.log( Date.now() ); // fastest
    console.log( + new Date() );
    console.log( (new Date()).getTime() );

    // convert to timestamp
    console.log( Math.round(Date.now()/1000) )
