echo off
REM # batch file
REM #
REM #
REM # This script is meant to automate a home folder move to storage.
REM # An auxiliary  folder for scanner file is also moved.
REM #
REM #
REM # This is nice to have if you want to take old user data out of
REM # production backup's or just archive the user data.
REM #
REM # It should be pretty simple to adapt this to Amazon Glacier or S3
REM # Just replace the move commands with the approriate S3CMD or Glacier call.
REM #
REM # Assumptions that will need to be customized for your system:
REM #
REM # home folder is on e:
REM # scan folder is on e:
REM # home folder will be shared as username$
REM # scan folder will be within a share
REM #
REM # Command line to create fodlers:
REM # store-user [username]   
REM #
REM #
REM #  Tested on Server 2008 R2
REM #
REM #
set base_drive=e:
set home_folder=\home
set home_path=e:\home
set scan_path=e:\scan
set store_path=e:\storage\recent

%base_drive%
cd %home_folder%

set name=%1

if "%1 "==" " (

 set /p name="Enter Username: "

)

net user %name% /domain > nul
if not errorlevel 1  ( 
 echo Username Exists, delete user first, then run this script.
 goto end
)
if "%name% "==" " ( 
 echo Username required
 goto end
)

if not exist %home_path%\%name% goto move
net share %name%$ > nul
if not errorlevel 1 (
echo Share exist, deleting %name%$
net share %name%$ /delete
)

:move

move %home_path%\%name% %store_path%\
if not exist %store_path%\%name%\scan mkdir %store_path%\%name%\scan
move %scan_path%\%name% %store_path%\%name%\scan


 
:end
