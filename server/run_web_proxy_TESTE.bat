@echo off
title World War Web Proxy (TESTE SEM SSL)
echo Starting OTClient Web Proxies in NO-SSL Mode...
echo.
echo [1/2] Starting Login Proxy (8081 -> 7171)...
start python -m websockify 8081 127.0.0.1:7171
echo.
echo [2/2] Starting Game Proxy (8082 -> 7172)...
start python -m websockify 8082 127.0.0.1:7172
echo.
echo ==========================================
echo TEST PROXIES RUNNING (NO SSL)!
echo Use these for testing basic connection.
echo ==========================================
pause
