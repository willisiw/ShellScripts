@echo off
REM This batch file tests folders against users in the home folder
REM it will generate a scripts which can be used to create missing 
REM folders based on the results.

REM Set the next four lines to change toyour base folder where home
REM folders are stored.
set HOMEFOLDER=e:\home
set SCANFOLDER=e:\scan
e:
cd \home


date /t  >  CheckUserstoFolders.log
for /f %%i in ('net user /domain') do call :checkuser %%i



:checkuser

set name=%1

Rem skip garbage out from net user /domain command
if "%name% "=="The " ( 
 goto end
)
if "%name% "=="------------------------------------------------------------------------------- " ( 
 goto end
)
if "%name% "=="User " ( 
  goto end
)
if "%name% "==" " ( 
 goto end
)

if not exist %HOMEFOLDER%\%name% echo [%name%] has no home folder  >>  CheckUserstoFolders.log
if not exist %SCANFOLDER%\%name% echo [%name%] has no scan folder  >>  CheckUserstoFolders.log


net share %name%$ > nul
if errorlevel 1 (
 echo [%name%$] not shared   >>  CheckUserstoFolders.log
 echo mk-user-home.bat %name% >> CreateHomeFolders.cmd2
 REM CreateHomeFolders.cmd2 assumes that you have another script named
 REM mk-user-home.bat to create user shares.

)


 
:end
