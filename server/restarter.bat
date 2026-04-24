@echo off
title World War Auto Restarter
cd /d %~dp0
:start
echo [%date% %time%] Starting World War Server...
theforgottenserver-x64.exe
echo [%date% %time%] Server closed or crashed! Restarting in 5 seconds...
timeout /t 5 /nobreak
goto start
