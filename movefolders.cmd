echo off
REM This batch file uses a list of folders in "sourcedir" to move the same named folders 
REM out of "cleanup" folder into "destdir" folder.

REM this is useful when you need to move a specific set of folders over and over
REM based on a baseline folder set. 

set sourcedir=C:\base\folders
set cleanup=C:\wamp\www\folders
set destdir=C:\wamp\www2\folders

for /f %%i IN ('dir /ad /b "%sourcedir%"') DO move "%cleanup%\%%~i" %destdir%
