@echo off
REM This batch file tests folders against users in the home folder
REM it will generate two scripts which can be used to fix permissions based
REM on the results.  It will also log folders that do not match a username.

REM drive = the drive letter where home folders are stored.
REM home = the base folder for home drives.
REM log = the full path to where you want logs stored.
set drive=g:
set home=\home
set log=g:

%drive%
cd %home%



date /t  >  %log%\_Folders_with_no_User.log
for /f %%i in ('dir /ad /b %drive%%home%') do call :checkfoldertouser %%i

goto :end



:checkfoldertouser

set name=%1
echo %name%

if "%name% "==" " ( 
 echo [%name%] is not a Valid Username
 goto end
)


REM Identify folders without a valid username.
net user %name% /domain > nul
if errorlevel 1  ( 
 echo %name% folder does not match a Valid Username
 echo %name% >>   %log%\_Folders_with_no_User.log
 goto end
)

REM We have a valid username at this point, lets do something with it.


 echo [%name%] is a valid home folder.
 echo [%name%] >>   %log%\_Username_Folders.log

 REM this line adds a command to a script to add FULL permisions for a user
 REM to the matching folder.
 echo cacls %drive%%home%\%name% /e /g %name%:F  >>   %log%\_Fix_Folders.cmd 


:end
