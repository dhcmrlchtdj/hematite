=====================
 mencoder and ffmpeg
=====================

information
============

.. code::

    $ ffmpeg -i input.mpg
    $ mplayer -ao dummy -vo dummy -identify input.mpg

-------------------------------------------------------------------------------

codecs and formats
===================

.. code::

    $ mencoder -ovc help
    $ mencoder -oav help
    $ mencoder -of help
    $ mencoder -vf help

-------------------------------------------------------------------------------

rescale
========

.. code::

    $ mencoder input.mpg -oav copy -ovc copy -vf scale=1280:720 -o output.avi

-------------------------------------------------------------------------------

extract
========

.. code::

    # audio
    $ mencoder input.mpg -of rawaudio -ovc copy -aid 0 -oac faac \
    > -faacopts quality=1000:tns -o output.aac
    $ ffmpeg -i input.mkv -vn -acodec copy output.aac

    # video
    $ mencoder input.mpg -of rawvideo -vid 0 -oac faac -ovc copy -o output.mp4

    # sub
    $ ffmpeg -i input.mkv -vn -an -codec:s srt all.srt
    $ ffmpeg -i input.mkv -vn -an -codec:s:0 srt first.srt

-------------------------------------------------------------------------------

add external audio
===================

.. code::

    $ mencoder -oac copy -audiofile filename

-------------------------------------------------------------------------------

threads
========

.. code::

    $ mencoder -ovc lavc -lavcopts threads=N

-------------------------------------------------------------------------------

encoding options
=================

.. code::

    # very hight quality
    $ mencoder -ovc lavc -lavcopts \
    > vcodec=mpeg4:mbd=2:trell:v4mv:vmax_b_frames=2:vb_strategy=1:\
    > last_pred=3:cmp=2:subcmp=2:precmp=2:mv0:cbp:preme=2:qns=2:predia=2

    # hight quality
    $ mencoder -ovc lavc -lavcopts \
    > vcodec=mpeg4:mbd=2:trell:v4mv:vmax_b_frames=2:vb_strategy=1:\
    > last_pred=2:cmp=3:subcmp=3:precmp=0:dia=-1:vqcomp=0.6:turbo

-------------------------------------------------------------------------------

merge videos
=============

.. code::
    
    $ mencoder -oac copy -ovc copy part1.avi part2.avi -o full.avi
