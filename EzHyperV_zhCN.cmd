@echo off
title EzHyperV
echo 欢迎来到 EzHyperV! 正在请求管理员权限...
choice /t 2 /d y /n >nul
:: 停顿两秒，让用户可以看见程序在做什么
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
:: 用vbs请求管理员权限
echo EzhyperV by github@kevinweng-git 
echo 来看看我的github仓库并且给个star吧!
echo https://github.com/kevinweng-git/EzHyperV
echo ==============
echo 按任意键即可在您的设备上部署Hyper-V。
echo 请确认你的设备运行的是Windows10/11.
pause >nul
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V-All /LimitAccess /ALL
:: 使用DISM部署Hyper-V
echo 操作完成。按任意键来重启电脑，或关闭窗口即可继续但不重启
pause >nul
shutdown -r -t 5
exit