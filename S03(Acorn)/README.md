* Vxx official Acorn release
* Dxx Russian bootleg, Russian audio instead of French, video is the same

Season 3 episodes are mostly "progressive", the second field is just a fake interpolated image of the first field (S03E02 uses point sampling mostly...). One way to deal with this is to throw away the second field and upscale it with a better algorithm again. The problem is, the second field is still missing, diagonal lines will never really look diagonal, as scalers only operate in horizonal or vertical direction. 

Update: nnedi3 does a good job restoring those lines. It is close but still inferior to a 480p image. Becomes more apparent in Topaz Video AI upon further upscaling.

![Missing field example](./missing_field.png)

Interpolation is a problem, but it can also be used to squize out some redundant information.

    simple missing line interpolation 
    
    a (a+b)/2 b (b+c)/2 c ...
    
    the original value can be extracted from the rows above and below
    
    (a+b)/2*2-a => b
    (a+b)/2*2-b => a
    (b+c)/2*2-c => b
    (b+c)/2*2-b => c
    
    then take the average of every three rows to reduce noise created by compression
    
    o = c # c is the clip we are working on, save it for comparison

    a = Expr(c, "x[0,-1] 2.0 * x[0,-2] -")
    b = Expr(c, "x[0,+1] 2.0 * x[0,+2] -")
    c = Expr(a, b, c, "x y z + + 3.0 /")
    
    # this might be more optimizable, but I am not sure how Expr works internally
    # c = Expr(a, b, c, "x y + 0.5 * z + 0.5 *")

    # field number is the one that was not interpolated
    
    a = c.nnedi3(field=0)
    b = o.nnedi3(field=0)

    Overlay(a, b, mode="difference")

There are a few 59.94i scenes, where small features, like stars, are on alternating fields, a single field deinterlacer would mean losing a lot of detail and shimmering. There are also the usual hybrid scenes, 4 + 1 dup and 5 real frames layered on top of each other. These are harder to fix, as there are no redundant fields to choose from.

