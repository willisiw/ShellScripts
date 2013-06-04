echo off
cls
REM This batch file cleans temporary and cache folders on Windows 2000 - Windows 7



del %systemroot%\temp\*.* /f /s /q
del %temp%\*.* /f /s /q


Echo Delete User Temp and Cache files for 2000/xp/2003
Rem if the drive has a Documents and Settings folder, clean out the temps
if exist "%systemdrive%\Documents and Settings" (
for /f %%i IN ('dir /ad /b "%systemdrive%\documents and settings\"') DO del "%systemdrive%\documents and settings\%%~i\Local Settings\Temp\*.*" /s /f /q && del "%systemdrive%\documents and settings\%%~i\Local Settings\Temporary Internet Files\*.*" /f/s/q 
)


Echo Delete User Temp and Cache files for Windows Vista/7
Rem if the drive has a USERS folder, clean out the temps
if exist "%systemdrive%\users" (
for /f %%i IN ('dir /ad /b "%systemdrive%\users\"') DO del "%systemdrive%\users\%%~i\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*" /s /f /q && del "%systemdrive%\users\%%~i\AppData\Local\Temp\*.*" /f/s/q 
)


Rem Decide on the Windows folder and clean out the temps
if exist "%systemdrive%\windows" (
del %systemdrive%\windows\temp\*.* /f /s /q
)

if exist "%systemdrive%\winnt" (
del %systemdrive%\winnt\temp\*.* /f /s /q
)
