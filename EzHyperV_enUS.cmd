@echo off
title EzHyperV
echo Welcome to EzHyperV! Asking for Administrator privilege...
choice /t 2 /d y /n >nul
:: sleep for 2 seconds to let users know what the program is doing
cd /d "%~dp0"
cacls.exe "%SystemDrive%\System Volume Information" >nul 2>nul
if %errorlevel%==0 goto gotAdmin
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
echo Set RequestUAC = CreateObject^("Shell.Application"^)>"%temp%\getadmin.vbs"
echo RequestUAC.ShellExecute "%~s0","","","runas",1 >>"%temp%\getadmin.vbs"
echo WScript.Quit >>"%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" /f
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
exit
:gotAdmin
::use vbsscript to get admin privilege
echo EzhyperV by github@kevinweng-git 
echo Visit my github repository and give a star!
echo https://github.com/kevinweng-git/EzHyperV
echo ==============
echo Press any key to deploy Hyper-V on your device.
echo Please make sure that you are running Windows10/11.
pause >nul
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V-All /LimitAccess /ALL
echo Operation completed. Press any key to restart your computer in 5 seconds or close the window to continue without restarting.
pause >nul
shutdown -r -t 5
exit