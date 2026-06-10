@echo off
:: Set code page to UTF-8 to display Chinese correctly
chcp 65001 >nul

:: Run PowerShell script with Bypass execution policy in the same directory
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0启用_Chrome_AI.ps1"
