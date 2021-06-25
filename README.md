# Lexx IVTC

Attempting the impossible, IVTC overrides for Lexx NTSC DVDs

## Current progress

* S01 done (Koch, Alliance)

* S02 done (Acorn)

* S03/E01-09 done (these episodes are terrible quality, one field is simply missing in many places)

* S04 done (Acorn)

Planing to do newer releases if I can get them and are better quality.

Alliance S01 has about 10% more bitrate, however the picture is shifted to the right by a ~0.3 pixels. You can see this in the intro when there are point like stars in the background. Koch has nice single pixel stars, never covering two. S03 also has more data, only episodes 01-03 have the brightness increased and clipped. Another notable difference, the field order is swapped, this makes combining clips from different releases difficult, as there is no lossless way to convert the chroma plane between the two in the YV12 color space.

Still work in progress: 
* parity changing scenes, very time consuming, but there are not a lot
* interpolating new pp frames with MVTools where they were badly done decades ago, tests look promising
* S01, S02 done

## Encoding

Need a bunch of tools like avisynth, ffmpeg, dgindex, mpeg2dec, yadifmod2, eedi3, php... Also, some paths point to locations on my hard disk.

Use 32-bit avisynth, as the  64-bit port of mpeg2dec did not carry over the deblocking filters, they were written in assembly code and pretty messy.

The tfm overrides use the new Q parameter that I added, it can be found in my [TIVTC fork](https://github.com/gabest11/TIVTC/releases/). It's basically PP but ignores clip2.

First step is to rip every disc with mkvmerge.

0.bat title_tNN.mkv will demux the video elementary streams and call dgindex to produce the corresponding .d2v file. I work on elementary streams because the timestamps are stripped and if the disc is damaged the audio is easier to resync. There is a certain version floating on the internet which has a problem with S02E02. But this project isn't for that.

php 1.php title_tNN.mkv 1pass|2pass|fields will do tfm/tdec run and output a huffyuv compressed avi. 

The "fields" option creates avis for both fields and Topaz AI can be used to individually upscale those to 540p (higher is not recommended). This seems to be a better option for S03 than nnedi3. A special .avs file is also generated which maps to those 240p fields, with as many Trims as needed, could be thousands.

php 2.php input output h265/h264 preset vertical_res cfr will encode it into a usable file for further muxing with the audio. The input can be the huffyuv avi or %06d.png if you created those with Topaz AI.

## Topaz AI

As of now, the best looking result is produced by Artemis HQ 150% 720p. This is the only preset where the smaller faces don't look like aliens from the movie They Live. There is still a small chance, usually MQ or LQ can fix it.

Scenes where HQ is not recommended:
* S01E01 Receptionist sitting under the clock when filmed from further away. Kai vs His Divine Shadow inside the Lexx, Kai's face
* S01E02 TV screen, pixelation is not preserved
* any intentionally noisy display or scene, use AA or CG

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

One of the up pairs can be dropped.

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

In a few scenes, the fields are also further scrambled over the ccppc pattern. To simulate shaking, the screen is frequently moved around field-by-field.

Examples: 
* S01E01 Hands appearing on the display when Stanley wakes up at home
* S01E04 Every moth cockpit scene filmed from the front
* S04E02 Fighter jet scenes

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

Update: Recreating pp with MVTools is also an option.

Examples: (there are many, easy to find, just few of the ugliest looking)
* S02E01 Mantrid, at the beginning, the astronaut's helmet and face, just before descending into the shaft
* S02E04 Luvliner, fight on the edge of Lexx's bridge
* S02E05 Lafftrak, after landing on the small planet and exploring
* S02E06 Stan's Trial, green mask 
* S02E07 Love Grows, asian bikini girl talking into the microphone
* S02E09 791, when 791 is about to be sucked out through the gate towards the end

When a green screen is involved, some of the combed parts are lost and the sides are missing in the direction of motion.

### missing field

    1t 2t 3t 4t 5t
    1t 2t 3t 4t 5t

    tfm: c, +, Q 6 or yadif or anything that looks better
    tdec: v

Rare and short scenes, it can be found throughout the whole series.

    1t 2t 3t 3t 4t
    1t 2t 3t 3t 4t (fake second field)

    tfm: c, -
    tdec: f, ++-++ or +++-+

Third season, few episodes from the fourth. The second field is just interpolated, no more information can be extracted to increase the halved resolution. Edges are blocky, stairstep effect. Very sad. Maybe it was recorded in PAL somewhere in Europe and converted to NTSC this way.

## Scene continuity

TDecimate splits the video into segments of 5 frames by default and drops one of the two most similar. This does not line up with the scenes nicely, sometimes there is none, other times both scenes have a duplicate frame.

### nothing to drop
    
    17832,17907 ccppc
    17908,18045 pcccp

    17900,17909 pcccp pcc|pc ccppc
    17900,17909 ++++- +++|++ ++-++
    
There is a scene change without dups, TDecimate will may choose a frame it likes and drop it by mistake. The solution is to force video mode: 17905,17909 v.

    21874,21951 c
    21952,22019 pcccp
    
    21945,21959 ccccc cc|pcc cppcc

Video and film scenes are next to each other. Also just force it to be video, 21950,21954 v.

Note that TDecimate will not respect the v flag if - was already set in a previous f sequence, override it again with +.

### two frames to drop

    10,17 cppcc
    18,24 cppcc
    
    10,19 cppcc cpp|cp pcccp
    10,19 +-+++ +-+|+- ++++-

We need to keep one of the dups unfortunatelly. I usually choose to keep the one that is right next to the scene change, less noticeable.

### scene starts on a half frame

    34046,34242 ccppc
    34243,34474 ppccc
    
    34235,34244 cccpp ccc|pp cccpp
    34235,34244 +++-+ +++|?+ +++-+

The first field of the first p frame is paired with the last field of the previous frame. It will be a dup next time, but not the first time. TDecimate sees 5 different frames and will randomly drop one, and not necessarily the first p. We can force it by defining the second scene as f and -++++. Or if you want to preserve every frame, force the transition to be video, 34240,34244 v. 

This half frame is not always the best looking frame, but Q 3 will make it acceptable.
 
### drop the other dup frame

    ccppc => ccppc
    ++-++    +-+++
          => ccuuc
             +++-+
          => ccuuc
             ++++-

This can have a ripple effect on following scenes. You may have to play whack-a-mole and fix several before everything lines up, or eventually run into an unsolvabe situation and have to force a video section anyway, and then you achieved nothing. 

If you change between 0/9 or 5/4, the next group will be affected. If there was no mismatch before, now there is.

If you change from p to the previous c, and the scene ends on that c, you lose a whole frame.

u frames are also problematic at the end of the scene.

## Random dups and skips

There are a couple of methods used to fit a clip into a different time-frame. Both can result in an irregular pattern, with seemingly random p frames, that cannot be ivtc'ed.

### Fast motion

    S01E01 at 135444,135481
    
    0 13456 79012 34578 90134 56790 12356 78912 34
    1 23457 89013 45679 01235 67891 23457 89013 45

The two rows represent the fields, the numbers the frame offset starting from 135444. Grouping and wrap-around around after 9 is for readability.

If you watch carefully, there are fields without pairs (2,6,8,...). In a TFM override file, one frame cannot be split into two. The solution is to remap all the fields in the Avisynth script to whole frames (SelectEvery) and apply MFlowFPS to stretch the clip to its original length.

    FixSlowMoI(135444, 135481, 25000, pd = 0, f = [ \
        [0,0,2,1,3,3,4,5,6,7,8,9,10,10,12,11,13,13,14,15,16,17,18,19,20,20,22,21,24,23,26,25,27,27,28,29,30,30,32,31,34,33,36,35,37,37,38,39,40,40,42,41,44,43,46,45,47,47,48,49,50,50,52,51,54,53,56,55,57,57,58,59,60,60,62,61,64,63,66,65,67,67,68,69,70,70,72,71,74,73,75,75], \
        [], \
        [1,2,5,6,8,10,13,14,17,18,20,22,25,26,28,30,33,34,37,38,40,42,45,46,49,50,52,54,57,58,61,62,64,66,69,70,73,74,76,78,81,82,85,86,88,91] \
        ])
    
25000 is the frame rate numerator, 30000 would be the normal NTSC speed. It was chosen to match the output and the original frame count.

pd is the pulldown value. 0 means no pulldown, 1: ppccc, 2: cppcc, etc. Sometimes it is better to do a 23.976 fps interpolation, if the smoothness of 29.97 would feel out of place, there is also less interpolated frames. Although, the frame count is unpredictable, harder to match, try switching between pd = 2 or 3 if there is no way to get the right number.

First array selects the fields to make whole frames.

The function will also replace those single field frames with a clip created by nnedi3, and the third array is which maps them, even are numbers left alone, odd numbers are deinterlaced. It's basically the argument for Interleave(c, c.nnedi3).SelectEvery(fc, f[2]).

This clip is then inserted into its right place with Trim.

![Comparison](./utils/media/fastmo.mp4)

### Slow motion

    18785 cpccp ccpcc pccpc cpccp ccpcc pccpc cpccp ccpcc cpccp cccpc
          cpccp ccpcc pccpc ccpcc pcccp ccpcc pccpc cpccp ccpcc pccpc
    18835 cpccp ccpcc pccpc cpccp ccpcc pccpc cpccp cccpc cpccc pccpc
          cpccp ccpcc pcccp ccpcc cpccp ccpcc pccpc cpccp ccpcc pccpc
    18885 cpccp ccpcc pccpc cpccp ccpcc pccpc cpccc pccpc c 
          cpccp ccpcc cpccp cccpc cpccp ccpcc pccpc cpccp c

This time the fields are not numbered, I just used c to mark a field advancing and p to be a duplicate of the previous. 

A regular ccppc pattern would look like:

    ccpcc
    ccccp

As you can see, there is nothing that resembles regularity of the normal pattern. There might be a logic behind it, it was produced by an algorithm in some ancient video editor, but I have no idea how they managed to do it. Deleting fields here and there...

    FixSlowMoI(18785, 18925, 44300, pd = 0, f = [ \
        [0,2,3,5,6,8,9,11,12,14,15,17,18,20,21,23,24,26,27,29,30,32,33,35,36,38,39,40,42,43,45,46,47,49,50,52,53,55,56,58,59,61,62,64,65,67,68,70,71,73,74,76,77,79,80,82,83,85,86,87,89,90,92,93,94,96,97,99,100,102,103,105,106,108,109,111,112,114,115,117,118,120,121,123,124,126,127,129,130,132,133,134,136,137,139,140], \
        [0,2,3,5,6,8,9,11,12,14,15,16,18,19,21,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,47,49,50,52,53,55,56,58,59,61,62,63,65,66,68,69,70,72,73,75,76,78,79,81,82,84,85,87,88,90,91,93,94,96,97,99,100,102,103,105,106,108,109,110,112,113,115,116,117,119,120,122,123,125,126,128,129,131,132,134,135,137,138,140] \
        ])

This time both f[0] and f[1] are used, all the c fields are mapped, ignoring any p, separately in even and odd fields. 

There must be equal number of c's in each field, unless the list is wrong or there is one half frame at the beginning/end. That single field can be dropped.

The first method, with the numbers, could also be used here, but this was the first I came up with and there were already many scenes done with it. If there are no fields without pairs, this is usually easier to do.

![Comparison](./utils/media/slowmo.mp4)

### When parity changes

I think this is also a form of slow motion. This time the duplicate fields are not kept in the same row, just inserted in order, each one shifting the rest of the fields to the other row, horribly messing up the whole scene. A bob deinterlacer will hide the problem, but there is also a way to fix it.

First step, create a list of the fields grouped by temporal position, for example ccppc tff will look like hl hlh lh lhl. 3rd h still belongs to the second frame, as the 4th l to the last frame. Now if there is such a slow motion effect, the groups will have plus one field sometimes.

    S01E01 141676-
    hl hlh lh lhl hlh lhl hl hlhl
                  ? ?        ?  ?

Any of the fields marked by the question mark should be dropped, one from each group, which will also invert the parity for the rest. No way to tell which one, could be random, trial and error.

Let's drop the first h(?)

    hl hlh lh lhl HL HLH LH LHLH
                            ?  ?

Then the next L(?)

    hl hlh lh lhl HL HLH LH lhl
    or
    ccppc CCP(P/p)c

Avisynth will see the capitalized segments with the opposite parity. This can be used to conditionally shift the fields back to their place. This sub-pixel shift will blur them a bit. Still a lot better then Bob+Merge, or just watching the fields jumping around.

The amount of sub-pixel shift should be +/-0.5, but of course this is not the case. Acorn/Koch needs something like 0.75/-0.25, Alliance is more closer to half. I don't know if this the side-effect of the resizer's sampler, or the resizer used when the DVD was made.

After dropping the dups and restoring the vertical position, continue as above, IVTC and FixSlowMoI to match the frame count.

Examples
* S01E01: When the prisoners arrive on the transport ships, first scene right after the guard checks out Thodin in his walking cage.
* S01E01: Megashadow harpooning the Lexx
* S01E02: Flying towards the colony
* S01E03: Stanley getting impregnated
* S01E04: Shadow chasing Stanley on the bridge of the Lexx
