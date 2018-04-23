关闭图片缩放
=============

::

    $ cd ~/.config/google-chrome-unstable/Profile\ 1
    $ sed -i.bak '/webprefs/a \
    > "shrinks_standalone_images_to_fit": false,' Preferences

    $ # result
    $ cat Preferences
    ......
        },
        "webkit": {
            "webprefs": {
                ......
                "shrinks_standalone_images_to_fit":false,
                ......
            }
        }
    }
