========
 scheme
========

.. code::

    % scheme-script example.scm
    % petite

----------------------------------------------

+ number
  - 1
  - 1.1
+ string
  - "hello"
+ boolean
  - #t
  - #f

--------------------------------------

buildin function
=================

address 
data 

.. code::

    > (car '(1 2 3))
    1
    > (car '())
    Exception

    > (cdr '(1 2 3))
    (2 3)
    > (cdr '(1))
    ()
    > (cdr '())
    Exception

    > '(1 2)
    (1 2)
    > (quote (1 2))
    (1 2)

    > (cons 1 '(2 3))
    (1 2 3)
    > (cons '(1 2 3) '(4 5))
    ((1 2 3) 4 5)

    > (append '(1 2 3) '(4 5))
    (1 2 3 4 5)

-------------------------------------------------------------------------------

function
=========

.. code::

    > ; (define func_name (lambda (arg) (statement)))
      (define add (lambda (x y) (+ x y)))
    > (add 1 2)
    3

    > ; (if (test) (then_do) (else_do))
      (if (= 1 0) #t #f)
    #f










