# Lexx IVTC

Attempting the impossible, IVTC overrides for Lexx NTSC DVDs

## Current progress: 

* S01/E01-03 done (Koch)

* S02 done (Acorn)

* S03 (don't have the discs yet)

* S04/E01 done (Acorn)

Planing to do newer releases if I can get them and are better quality.

## Encoding

Need a bunch of tools like avisynth, ffmpeg, dgindex, mpeg2dec, yadifmod2, php... Also, some paths point to locations on my hard disk.

Use 32-bit avisynth, as the  64-bit port of mpeg2dec did not carry over the deblocking filters, they were written in assembly code and pretty messy.

The tfm overrides use the new Q parameter that I added, it can be found in my TIVTC fork. It's basically PP but ignores clip2.

First step is to rip every disc with mkvmerge.

0.bat title_tNN.mkv will demux the video elementary streams and call dgindex to produce the corresponding .d2v file. I work on elementary streams because the timestamps are stripped and if the disc is damaged the audio is easier to resync. There is a certain version floating on the internet which has a problem with S02E02. But this project isn't for that.

php 1.php title_tNN.mkv will do a two pass tfm/tdec run and output a huffyuv compressed mkv.

php 2.php input output h265/h264 preset vertical_res cfr will encode it into a usable file for further muxing with the audio. The input can be the huffyuv mkv or %06d.png if you created those with Topaz AI.

## Topaz AI

As of now, the best looking result is produced by Artemis HQ 150% 720p. This is the only preset where the smaller faces don't look like aliens from the movie They Live. There is still a small chance, usually MQ or LQ can fix it.

## How to apply TIVTC overrides effectively

### Not hybrid, ccppc

    1t* 2t* 2t* 3t* 4t*
    1b* 2b* 3b* 4b  4b*

    1c  2c  2p  3p  4c

    tfm: ccppc, -----
    tdec: f, +-+++ or ++-++

There are many alternatives, ccppc could be cuuuc, or anything that selects four different whole frames. Only the first c is not redundant.

Why would you want to do this when TIVTC can field-match and decimate automatically? You will notice that noisy or slow moving parts will break its ability to produce consistent patterns. Lexx has many of those. It will not look too different, but it does. If a c/p is mistaken outlines can stay zebra stipped and textures are just fuzzier.

### pp overlap, ccppc + cccpp

    ccppc

    1t* 2t* 2t  3t* 4t*
    1b* 2b* 3b* 4b* 4b

    cccpp

    1t* 2t* 3t  3t* 4t* 5t
    1b* 2b* 3b* 4b* 5b  5b

    1c  2c  xx  3p  4p

    tfm: ccxpp, -----
    tdec: f, ++-++

x can be anything, that's the one we will drop. 

Drop the first p as a general rule.

### pp does not overlap, ccppc + pcccp

    ccppc

    1t* 2t* 2t  3t  4t*
    1b  2b* 3b* 4b* 4b

    pcccp

    1t* 2t* 3t  4t  4t* 5t  6t
    2b  2b* 3b* 4b* 5b  6b  6b

    1h  2c  3l  4u  5p

    tfm: hclup, +-+--, Q 6
    tdec: f, ++++-

Must use tfm's deinterlacer that understands h/l to be top or bottom field, no clip2. Drop either of the last two frames, they are identical.

This method is obviously lossy, since we only keep two clean frames and make the deinterlacer guess the second half of the other two. Because they are surrounded by clean frames, the result is pretty good with motion-adaptive deinterlacers. Certainly better than deinterlacing every frame.

If your pattern starts differently, just rotate the overrides. pcccp + cppcc => uphcl, --+-+ and f, +-+++

### More layers, cppcc + ccppc + cccpp

    cppcc

    1t* 1t  2t  3t* 4t*
    1b* 2b* 3b* 3b  4b

    ccppc

    1t* 2t  2t  3t* 4t* 
    1b* 2b* 3b* 4b  4b

    cccpp

    1t* 2t  3t  3t* 4t* 
    1b* 2b* 3b* 4b  5b 

    1c  2l  3u  3p  4h

    tfm: cluph, -+--+, Q 6
    tdec: f, +++-+ or ++-++
    
Surprisingly similar to the two layer solution.

Example: 
* Mantrid's first appearance with the many arms flying around
* During Thodin's trial, holograms, crowd and the stadium

### More layers, but no common c, ppccc + ccppc + cccpp

    ppccc

    1t  2t  3t  4t  5t 
    2b  3b  3b  4b  5b

    ccppc

    1t  2t  2t  3t  4t  
    1b  2b  3b  4b  4b

    cccpp

    1t  2t  3t  3t  4t  
    1b  2b  3b  4b  5b 

    1h  2h  3l  4l  5x

    tfm: hhllx, ++++-, Q 6
    tdec: f, ++++-
    
Not a single clean frame, maybe when smooth motion is needed.

### ccppc + 29.97p or 59.94i

There is no good solution, what I do is leave the more pronounced part of the picture untouched and deinterlace or drop frames from the other.

#### 29.97p

If the ccppc part is small or stationary but the other has to look smooth. (moving background)

    tfm: ccppc, --++-
    tovr: v, +++++

Otherwise, if ivtc is more important that smoothness.

    tfm: ccppc, --++-
    tovr: f, ++-++

#### 59.94i

Not much to do here, deinterlace every frame.
