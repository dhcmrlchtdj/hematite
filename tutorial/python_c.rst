c api
======

``sample.h``

.. code:: c

    int gcd(int, int);


``sample.c``

.. code:: c

    #include <math.h>
    #include "sample.h"

    int gcd(int x, int y) {
   
    }


``pysample.c``

.. code:: c

    #include "Python.h"
    #include "sample.h"

    static PyObject *py_gcd(PyObject *self, PyObject *args) {
        int x, y, result;
        if (!PyArg_ParseTuple(args, "ii", &x, &y)) return NULL;
        result = gcd(x, y);
        return Py_BuildValue("i", result);
    }

    static PyMethodDef SampleMethods[] = {
        {"gcd", py_gcd, METH_VARARGS, "greatest common divisor"},
        {NULL, NULL, 0, NULL}
    };

    static struct PyModuleDef samplemodule = {
        PyModuleDef_HEAD_INIT,
        "sample", // name
        NULL, // doc string
        -1,
        SampleMethods
    };

    PyMODINIT_FUNC PyInit_sample(void) {
        return PyModule_Create(&samplemodule);
    }


``setup.py``

.. code:: python

    from distutils.core import setup, Extension

    args = {
        "name": "sample",
        "sources": ["pysample.c"],
        "library_dirs": ["."],
        "libraries": ["sample"],
    }
    ext = Extension(**args)
    setup(name="sample", ext_modules=[ext])


build commond

.. code::

    # build c shared library
    $ gcc -fPIC -c sample.c -o sample.o
    $ gcc -shared -Wl,-soname,libsample.so -o libsample.so sample.o
    $ export LD_LIBRARY_PATH=.

    # build python library
    $ python setup.py build_ext --inplace
