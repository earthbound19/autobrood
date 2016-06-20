REM DESCRIPTION: Renders a collection of fractal flame genomes (animated) at a given quality, depending on SET parameters, using flam3-genome and flam3-animate.

REM USAGE: Pass this script one paramater, being the file name of a file with assembled fractal flame genomes.

ECHO OFF

REM REFERENCE:
REM take an existing input fractal flame genome (test.flam3), and create a sequence of 30 frames in one looping animation; bash:
	REM env sequence=test.flam3 nframes=30 flam3-genome > seq.flam3
REM as DOS:
	REM SET sequence=test.flam3
	REM SET nframes=30
	REM flam3-genome > seq.flam3
	
REM NOTE: If test.flam3 contains two fractal flames (which probably must be SET in a <flames> SET of tags, e.g. <Flames name="2016-06-10__06-43-13_AM_many_flames">), this will produce 30 x 3 = 90 frames: 30 of the first genome looping once, 30 of the first genome transitioning to the second, and 30 of the second genome looping once.

SET currdir=%cd%
SET sequence=%1%
SET enable_png_comments=0
REM SET animate=0 NO -- that breaks it.
SET name_enable=1
SET nick=earthbound
SET noedits=unset
SET nframes=120
SET ss=0.18
	REM ECHO SEQ is %sequence%
flam3-genome > %sequence%_%nframes%fpt_anim.flam3
flam3-animate < %sequence%_%nframes%fpt_anim.flam3

REM DEVELOPMENT HISTORY:
REM 06/13/2016 12:50:50 PM initial feature complete. -RAH

REM TO DO:
REM do not overwrite pre-existing environment variables (use them).
REM RENDER FRAMES INDIVIDUALLY instead (don't use this batch), because there is not any option to not clobber existing target renders. Unless you want motion blur in the animation; then you must use flam3-genome OR somehow add the motion blur in the process of rendering or in post. ?