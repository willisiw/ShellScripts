@echo off
REM # batch file
REM
REM
REM # This script is meant to automate a home folder creation on a fileserver.
REM # An auxilluary folder for scanner files is also created.
REM
REM # Assumptions that will need to be customized for your system:
REM
REM # home folder is on e:
REM # scan folder is on e:
REM # home folder will be shared as username$
REM # scan folder will be within a share
REM
REM # Command line to create fodlers:
REM # mk-user-home [username]   
REM
REM #  Tested on Server 2008 R2


set base_drive=e:
set home_folder=\home
set home_path=e:\home
set scan_path=e:\scan


%base_drive%
cd %home_folder%

set name=%1

if "%1 "==" " (
 REM # prompt if not username given.
 set /p name="Enter Username: "

)

net user %name% /domain > nul
if errorlevel 1  ( 
 echo Valid Username required
 goto end
)

if "%name% "==" " ( 
 echo Valid Username required
 goto end
)

if exist %name% (

 echo Folder exists, removing share %name%$

 net share %name%$ /delete


) ELSE (

 echo folder does not exist, creating %name%
 mkdir %name%

)



echo+
echo Sharing %name%$
echo+
echo+
net share %name%$=%home_path%\%name% /grant:%name%,change /grant:"%USERDOMAIN%\Domain Admins",full
echo+
net share %name%$

echo+
echo Making scan folder
echo+
if not exist %scan_path%\%name% mkdir %scan_path%\%name%

 
:end
echo Paused for 5 seconds...
ping -n 5 127.0.0.1 > nul
