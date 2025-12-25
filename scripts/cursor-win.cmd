@echo off
REM cursor-win.cmd
REM Batch file wrapper for cursor-win.ps1 to allow calling "cursor-win" directly
REM This allows the command to work from cmd.exe as well as PowerShell

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0cursor-win.ps1" %*

