@echo off
title World War Web Proxy (SSL)
echo Starting OTClient Web Proxies...
echo.
echo [1/2] Login Proxy: WSS (Port 8081) -> TCP (Port 7171)
start python -m websockify 8081 127.0.0.1:7171 --cert="c:\aethrium-war\server\stunnel.pem"
echo.
echo [2/2] Game Proxy: WSS (Port 8082) -> TCP (Port 7172)
start python -m websockify 8082 127.0.0.1:7172 --cert="c:\aethrium-war\server\stunnel.pem"
echo.
echo ==========================================
echo PROXIES RODANDO!
echo Liberar no roteador: 8081 e 8082 (TCP)
echo ==========================================
pause
