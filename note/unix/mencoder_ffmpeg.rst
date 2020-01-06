.. contents::



information
============

::

    $ ffmpeg -i input.mpg
    $ mplayer -ao dummy -vo dummy -identify input.mpg






codecs and formats
===================

::

    $ mencoder -ovc help
    $ mencoder -oav help
    $ mencoder -of help
    $ mencoder -vf help






rescale
========

::

    $ mencoder input.mpg -oav copy -ovc copy -vf scale=1280:720 -o output.avi






extract
========

::

    # audio
    $ mencoder input.mpg -of rawaudio -ovc copy -aid 0 -oac faac \
    > -faacopts quality=1000:tns -o output.aac
    $ ffmpeg -i input.mkv -vn -acodec copy output.aac

    # video
    $ mencoder input.mpg -of rawvideo -vid 0 -oac faac -ovc copy -o output.mp4

    # sub
    $ ffmpeg -i input.mkv -vn -an -codec:s srt all.srt
    $ ffmpeg -i input.mkv -vn -an -codec:s:0 srt first.srt







add external audio
===================

::

    $ mencoder -oac copy -audiofile filename







threads
========

::

    $ mencoder -ovc lavc -lavcopts threads=N







encoding options
=================

::

    # very hight quality
    $ mencoder -ovc lavc -lavcopts \
    > vcodec=mpeg4:mbd=2:trell:v4mv:vmax_b_frames=2:vb_strategy=1:\
    > last_pred=3:cmp=2:subcmp=2:precmp=2:mv0:cbp:preme=2:qns=2:predia=2

    # hight quality
    $ mencoder -ovc lavc -lavcopts \
    > vcodec=mpeg4:mbd=2:trell:v4mv:vmax_b_frames=2:vb_strategy=1:\
    > last_pred=2:cmp=3:subcmp=3:precmp=0:dia=-1:vqcomp=0.6:turbo







merge videos
=============

::

    $ mencoder -oac copy -ovc copy part1.avi part2.avi -o full.avi







录制视频
=========

::

    $ ffmpeg -f x11grab -s wxga -r 30 -i :0.0 output.mp4
    # -f 输入来源
    # -s 分辨率 宽x高
    # -r 帧率
    # -i 从 0.0 处开始录制，可以自己制定偏移量
    # `man 1 ffmpeg-utils` 可以找到各种比例的缩写和帧率的缩写
    # `man 1 ffmpeg` 找 x11 可以看到示例



mov to gif
=============

https://gist.github.com/dergachev/4627207

::

    $ ffmpeg -i in.mov -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > out.gif

+ ``-r 10`` tells ffmpeg to reduce the frame rate from 25 fps to 10
+ ``-s 600x400`` tells ffmpeg the max-width and max-height
+ ``--delay=3`` tells gifsicle to delay 30ms between each gif
+ ``--optimize=3`` requests that gifsicle use the slowest/most file-size optimization
