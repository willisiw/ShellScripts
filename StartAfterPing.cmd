@echo off
rem #
rem # Written by Ian Willis 2010-10-10
REM Launch an application ONLY if we can ping an address.
REM Loop until we do ping.

set shortcut=c:\Notepad.lnk
set server=www.example.com


:PING
ping %server%
if %errorlevel%==1 (
 Echo "Ping failed."

)
if %errorlevel%==0 (
 msg %USERNAME% "Ping succeded, Application %shortcut% will start now."
 start %shortcut%
 goto exit

)

echo+
echo+
echo+
echo+
echo+
echo+
REM This will loop after waiting 30 seconds
echo Paused for 30 seconds...
ping -n 30 127.0.0.1 > nul
cls
goto :PING


:exit
