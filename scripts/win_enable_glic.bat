@echo off
:: Set console code page to UTF-8 to display Chinese characters correctly
chcp 65001 >nul

:: Run the PowerShell script located in the same directory, bypassing execution policy
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0win_enable_glic.ps1"
