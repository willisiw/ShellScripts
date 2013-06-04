@echo off
REM This batch file tests folders against users in the home folder
REM it will generate two scripts which can be used to cleanaup based
REM on the results.

REM Set the next two lines to change toyour base folder where home
REM folders are stored.
e:
cd \home



date /t  >  CheckFolderstoUsers.log
for /f %%i in ('dir /ad /b e:\home') do call :checkfoldertouser %%i

goto :end



:checkfoldertouser

set name=%1
echo %name%

if "%name% "==" " ( 
 echo [%name%] Valid Username required
 goto end
)


REM Identify folders without a valid username.
net user %name% /domain > nul
if errorlevel 1  ( 

 echo %name% is not a Valid Username  >>   CheckFolderstoUsers.log
 echo move %name% e:\Storage\%name% >> CleanupHomeFolders.cmd1
 goto end
)

REM Identify vaild user folders which are not shared as a windows share.
net share %name%$ > nul
if errorlevel 1 (
 echo [%name%$] not shared  >>   CheckFolderstoUsers.log
 echo mk-user-folder.cmd %name% >> CreateHomeFolders.cmd1
 REM CreateHomeFolders.cmd1 assumes that you have another script named
 REM mk-user-folder.cmd to create user shares.
)


:end
