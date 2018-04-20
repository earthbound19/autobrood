ECHO OFF
color 2A
ECHO ================================================================
ECHO Look in this folder and in the children folder (which this batch
ECHO creates) when it runs.
ECHO ================================================================
PAUSE

REM So you can call the batch from this directory:
SET CURRENT=%CD%
SET PATH=%PATH%;%CD%
CD ..\..
CALL set-env
CD %CURRENT%

REM You can learn how these batches work by watching them
REM operate on the command line.
REM It is not necessary to prefix these with the "call" command
REM when running them from the command-line.

call render-sheep-thumbs
call breed-sheep
cd children
call render-sheep-thumbs

ECHO DONE.