@echo off
title Concrete QC Dashboard - Morava Corridor
set "HTML=%~dp0ConcreteQC_Dashboard.html"
set "DATA=%~dp0ConcreteQC_Data.js"

:: Sanity check - HTML must exist
if not exist "%HTML%" (
  echo ERROR: ConcreteQC_Dashboard.html not found in this folder.
  echo Path: %HTML%
  pause
  exit /b 1
)

:: Warn if shared data file is missing (dashboard will still open with embedded fallback)
if not exist "%DATA%" (
  echo WARNING: ConcreteQC_Data.js not found. Dashboard will show embedded fallback data only.
  echo Expected: %DATA%
  echo.
)

:: Find Chrome
set "CHROME="
for %%P in (
  "%ProgramFiles%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
  "%LocalAppData%\Google\Chrome\Application\chrome.exe"
) do if exist %%P set "CHROME=%%~P"

if not defined CHROME (
  echo Chrome not found. Opening in default browser...
  start "" "%HTML%"
  exit /b
)

start "" "%CHROME%" --app="file:///%HTML:\=/%" --window-size=1500,950 --disable-extensions
