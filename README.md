# Lexx IVTC

Attempting the impossible, IVTC overrides for Lexx NTSC DVDs

## Current progress

* S01/E01-03 done (Koch)

* S02 done (Acorn)

* S03 (don't have the discs yet)

* S04/E01 done (Acorn)

Planing to do newer releases if I can get them and are better quality.

## Encoding

Need a bunch of tools like avisynth, ffmpeg, dgindex, mpeg2dec, yadifmod2, php... Also, some paths point to locations on my hard disk.

Use 32-bit avisynth, as the  64-bit port of mpeg2dec did not carry over the deblocking filters, they were written in assembly code and pretty messy.

The tfm overrides use the new Q parameter that I added, it can be found in my [TIVTC fork](https://github.com/gabest11/TIVTC/releases/). It's basically PP but ignores clip2.

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

    1c  2c  3u  3p  4p

    tfm: ccupp, -----
    tdec: f, ++-++ or +++-+
    
    ... or alternatively if you need to drop another frame ...
    
    tfm: ccuup, -----
    tdec: f, +++-+ or ++++-

One of the up pairs can be droped.

### pp does not overlap, ccppc + pcccp

    ccppc

    1t* 2t* 2t  3t  4t*
    1b  2b* 3b* 4b* 4b

    pcccp

    1t* 2t* 3t  4t  4t* 5t  6t
    2b  2b* 3b* 4b* 5b  6b  6b

    1h  2c  3l  4u  4p

    tfm: hclup, +-+--, Q 6
    tdec: f, ++++-

Must use tfm's deinterlacer that understands h/l to be top or bottom field, no clip2. Drop either of the last two frames, they are identical.

Update: It is now possible to use yadif or other external deinterlacers if you use my TIVTC build. The clip3 argument takes a secondary clip for PP and uses it for the non-default field. In that case Q 6 can be omitted.

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

Examples: 
* Mantrid's first appearance with many arms flying around
* During Thodin's trial, holograms, crowd and the stadium
* S02E01 right at the beginning, a spaceship flying towards a planet

### More layers, but no common c, ppccc + ccppc + cccpp

    ppccc

    0t  1t  2t  3t* 4t*
    1b* 2b* 2b  3b  4b

    ccppc

    1t  2t  2t  3t* 4t* 
    1b* 2b* 3b  4b  4b

    cccpp

    1t  2t  3t  3t* 4t* 
    1b* 2b* 3b  4b  5b 

    1l  2l  xx  3h  4h

    tfm: llxhh, +, Q 6
    tdec: f, ++-++
    
Not a single clean frame, maybe when smooth motion is needed.

### ccppc + 29.97p or 59.94i

There is no good solution, what I do is leave the more pronounced part of the picture untouched and deinterlace or drop frames from the other.

#### 29.97p

If the ccppc part is small or stationary but the other has to look smooth. (moving background)

    tfm: ccppc, --++-
    tdec: v, +++++

Otherwise, if ivtc is more important than smoothness.

    tfm: ccppc, --++-
    tdec: f, ++-++

#### 59.94i

Not much to do here, deinterlace every frame. Or make interlaced h264. DVD extras are mostly 59.94i.

### ccppc, but already deinterlaced to 29.97 by blending

    ccppc

    1t  2t  [(2t+3b)/2]t  [(3t+4b)/2]t  4t 
    1b  2b  [(2t+3b)/2]b  [(3t+4b)/2]b  4b

Currently there is no way to fix this, but if my theory is correct, there is. 

We need 3b and 3t, every information is there, except the difference to the original caused by the lossy mpeg compression and the LSB after /2.

    3t = [(2t+3b)/2]t*2 - 2t
    3b = [(3t+4b)/2]b*2 - 4b

There is also the 1 row shift to take into consideration when (un)blending top and bottom fields.

TIVTC could do this if there was an override implementing this transformation, like ccxyc.

When there is small movement, and the ghosting in one frame is nicer then in two, 23.976 can be achieved by simply blending again. In this new frame 3t and 3b are both present, and also 2t and 4b, with their interpolated false field. Set a blending deinterlacer.

    tfm: ccupc, --++-, Q 5
    tdec: f, +++-+ or ++-++

    u=p, drop whichever can join up with the surrounding scenes

    if the fields are reversed: ccnbc

Altough, the Lexx uses a fancier deinterlacer, it tries to recreate four temporally unique fields out of pp, we can still blend the two in the middle. It gives a similar looking result as above, most of the time... Except there is no way to tell which the middle two are. The order is not always the same, only the pairs are. t1 t2 t3 t4, t2 t1 t3 t4, t1 t2 t4 t3... Can even alternate during the same scene.

The only "correct" way to deal with this, if you can tolerate the ghosting in two frames:

    tfm: ccccc, --++-, Q 5
    tdec: v

Examples: (there are many, easy to find, just few of the ugliest looking)
* S02E01 Mantrid, at the beginning, the astronaut's helmet and face, just before descending into the shaft
* S02E04 Luvliner, fight on the edge of Lexx's bridge
* S02E05 Lafftrak, after landing on the small planet and exploring
* S02E06 Stan's Trial, green mask 
* S02E07 Love Grows, asian bikini girl talking into the microphone
* S02E09 791, when 791 is about to be sucked out through the gate towards the end

When a green screen is involved, some of the combed parts are lost and the sides are missing in the direction of motion.
